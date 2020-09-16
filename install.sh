#!/bin/sh

package='./install.sh'
forceyes=false

# parse args
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "$package - install gdb-peda, gdb-pwndbg, and gdb-gef"
            echo " "
            echo "$package [options]"
            echo " "
            echo "options:"
            echo "-h, --help                show brief help"
            echo "-y, --yes                 yes to all"
            exit 0
            ;;
        -y|--yes)
            forceyes=true
            break
            ;;
        *)
            break
            ;;
    esac
done

MY_DIRECTORY=`pwd`

echo "[+] Checking for required dependencies..."
if command -v git >/dev/null 2>&1 ; then
    echo "[-] Git found!"
else
    echo "[-] Git not found! Aborting..."
    echo "[-] Please install git and try again."
fi

if [ -f ~/.gdbinit ] || [ -h ~/.gdbinit ]; then
    echo "[+] backing up gdbinit file"
    cp ~/.gdbinit ~/.gdbinit.back_up
fi

# download peda and decide whether to overwrite if exists
if [ -d ~/peda ] || [ -h ~/.peda ]; then
    echo "[-] PEDA found"

    if [ "$forceyes" != true ]; then
        read -p "skip download to continue? (enter 'y' or 'n') " skip_peda
    else
        skip_peda='n'
    fi

    if [ $skip_peda = 'n' ]; then
        rm -rf ~/peda
        git clone https://github.com/longld/peda.git ~/peda
    else
        echo "PEDA skipped"
    fi
else
    echo "[+] Downloading PEDA..."
    git clone https://github.com/longld/peda.git ~/peda
fi


# download pwndbg
if [ -d ~/pwndbg ] || [ -h ~/.pwndbg ]; then
    echo "[-] Pwndbg found"

    if [ "$forceyes" != true ]; then
        read -p "skip download to continue? (enter 'y' or 'n') " skip_pwndbg
    else
        skip_pwndbg='n'
    fi

    if [ $skip_pwndbg = 'n' ]; then
        rm -rf ~/pwndbg
        git clone https://github.com/pwndbg/pwndbg.git ~/pwndbg

        cd ~/pwndbg
        ./setup.sh
        
        cd $MY_DIRECTORY
    else
        echo "Pwndbg skipped"
    fi
else
    echo "[+] Downloading Pwndbg..."
    git clone https://github.com/pwndbg/pwndbg.git ~/pwndbg

    cd ~/pwndbg
    ./setup.sh

    cd $MY_DIRECTORY
fi


# download gef
echo "[+] Downloading GEF..."
rm -rf ~/gef
git clone https://github.com/hugsy/gef.git ~/gef

echo "[+] Setting .gdbinit..."
cp gdbinit ~/.gdbinit

{
  echo "[+] Creating files..."
    cp gdb-peda /usr/bin/gdb-peda &&\
    cp gdb-pwndbg /usr/bin/gdb-pwndbg &&\
    cp gdb-gef /usr/bin/gdb-gef
} || {
  echo "[-] Permission denied"
    exit
}

{
  echo "[+] Setting permissions..."
    chmod +x /usr/bin/gdb-peda
    chmod +x /usr/bin/gdb-pwndbg
    chmod +x /usr/bin/gdb-gef
} || {
  echo "[-] Permission denied"
    exit
}

echo "[+] Done"
