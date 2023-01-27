#!/usr/bin/env bash

declare WORK_DIR="/lustre/scratch119/humgen/teams/hgi/hail/ibd_interval_15x/gcloud-vcf2mt/upload"

main() {
  local chromosome="$1"
  local chunk="${LSB_JOBINDEX}"
  local chunks="$2"

  echo "Starting upload ${chunk} of ${chunks} for chromosome ${chromosome}"

  local gvcf
  local gs_gvcf
  while read -r gvcf; do
    gs_gvcf="gs://ibd_interval_hail_gvcf/chr${chromosome}-vcfs/$(basename "${gvcf}" gz | tr : _)bgz"
    echo "** Uploading ${gvcf} to ${gs_gvcf}"
    gsutil cp "${gvcf}" "${gs_gvcf}"
  done < <(split -n "r/${chunk}/${chunks}" "${WORK_DIR}/vcfs/chr${chromosome}.fofn")

  echo "Done!"
}

main "$@"
