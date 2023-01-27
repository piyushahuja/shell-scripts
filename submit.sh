#!/usr/bin/env bash

declare WORK_DIR="/lustre/scratch119/humgen/teams/hgi/hail/ibd_interval_15x/gcloud-vcf2mt/upload"
declare PER_CHUNK="10"

calculate_chunks() {
  local files="$1"

  python3 <<-PYTHON
	from math import ceil
	print(ceil(${files}/${PER_CHUNK}))
	PYTHON
}

create_gs_fofn() {
  # FIXME Copy-and-pasting code around makes me cry :P
  local chromosome="$1"

  local gvcf
  local gs_gvcf
  while read -r gvcf; do
    gs_gvcf="gs://ibd_interval_hail_gvcf/chr${chromosome}-vcfs/$(basename "${gvcf}" gz | tr : _)bgz"
    echo "${gs_gvcf}"
  done < "${WORK_DIR}/vcfs/chr${chromosome}.fofn"
}

main() {
  local chromosome="$1"
  local files="$(wc -l < "${WORK_DIR}/vcfs/chr${chromosome}.fofn")"
  local chunks="$(calculate_chunks "${files}")"

  bsub -G hgi -q long \
       -J "ibdint_chr${chromosome}_gs_upload[1-${chunks}]%10" \
       -M 1000 -R "select[mem>1000] rusage[mem=1000]" \
       -o "${WORK_DIR}/logs/chr${chromosome}.%I.log" \
       -e "${WORK_DIR}/logs/chr${chromosome}.%I.log" \
       "${WORK_DIR}/upload.sh" "${chromosome}" "${chunks}"

  gsutil cp <(create_gs_fofn "${chromosome}") \
            "gs://ibd_interval_hail_gvcf/chr${chromosome}-vcfs/chr${chromosome}.fofn"
}

main "$@"
