alias cg='cd `git rev-parse --show-toplevel`'
alias ve='python3 -m venv .venv'
alias va='source .venv/bin/activate'
alias tf="/Users/pa11/Code/platonia/infra/aws/terraform"
alias lt='ls -lhSG'

function mu(){
    cd /Users/pa11/Code/piyushahuja.github.io;
    git add .
    git commit -m "Auto deployed"
    git push
}

function pblog(){
    cd /Users/pa11/Code/platonia/blog;
    git add .
    git commit -m "Auto deployed"
    git push
}

function phi(){
    cd /Users/pa11/Code/philosophy-cafe;
    git add .
    git commit -m "Auto deployed"
    git push
}

function cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F 
}