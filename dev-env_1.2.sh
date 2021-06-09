#! /bin/bash

set -e

VOLUME_NAME=${1:?"Use $0 <environment_folder> to start the development environment"}
FREE_PORT=${2:-8000}
CODE_PORT=${3:-8080}

function extract_payload {
    match=$(grep --text --line-number '^PAYLOAD:$' $0 | cut -d ':' -f 1)
	payload_start=$((match + 1))
    tail -n +$payload_start $0 | tar -xzf -
}

# $1 workdir
function create_dockerfile {
    ubuntu_version=`jq -cr '.host_ubuntu_version' ${VOLUME_NAME}/manifest.json`
    extra_pkgs=`jq -r '.extra_pkgs // "" | @sh' ${VOLUME_NAME}/manifest.json`
    sed -e "\
    s/@UBUNTU_VERSION@/${ubuntu_version}/;\
    s/@EXTRA_PKGS@/${extra_pkgs}/;\
    s/@ENV_FOLDER@/${VOLUME_NAME}/" Dockerfile.template > Dockerfile
}

function create_container {
    if [[ $(docker volume ls --filter "name=${VOLUME_NAME}" -q | wc -l ) -eq 0 ]]; then
        echo "creating volume and copying setup script into it"
        docker volume create --name ${VOLUME_NAME}
        docker run -it --rm -v ${VOLUME_NAME}:/workdir busybox \
            /bin/sh -c "mkdir -p /workdir/src && chown -R 1000:1000 /workdir"
    fi

    echo "Building the development container"
    docker build -t ${VOLUME_NAME} -f Dockerfile .
}

function start_container {
    echo "Cleaning up old containers"
    docker rmi $(docker images -qa -f 'dangling=true') || echo "Nothing to remove"

    echo "Starting the development container"
    docker run --rm -it -v ${VOLUME_NAME}:/home/yoctouser -p ${FREE_PORT}:8000 -p ${CODE_PORT}:8080 ${VOLUME_NAME}
}

function main {
    extract_payload
    create_dockerfile
    create_container
    rm -rf resources Dockerfile*
    start_container
}

main ${@}
exit 0

PAYLOAD:
�      �XYS�H�y~EG� 얐|�r┽X�`�|���#����+:����3�!�P����s�%��t�����O7�u�[?
�Tb��AII^����A�T,��\��$(�8�V��P���!�}���������_�_w*ԟP�����`.����T^����@y>�O��k�1$�0�
(��Wy��S���
8�C�N��C�
�k[�ṱ���H���nQ�yVO��r.��X��	l��1��Z0��m���|/P����2t}h��ޚ�6�!��q�*����t������l I�W�K�|���M#H��!s 2�P�q5E������C ��S�Dn��6����,�#>|� p����P}�p�a:�X�@��҈� }��3��������򀘲bn�%7em�Sק�;���<������� ]mI���ßU�S�/���R���%���	��D�������z�Fw��;9�}�:���a�/
��η�7ǮS Ɇqz�s��9\��\��x��:ĉ�$��.?V�?u�Е�3yvO�>_*������$�?!�V4�D��Z���]�T�B׵�J�~�jU�{v9=�H�x�b�ɶ�C��_�f�~xr�Tq���"}��$v�mM���K�}�b��`��┓ֹ:�YJ!���C�u��L�y��o�$�/g���nl҆4�����3s}8�k^��,�CS�ƍ¹�N� �hQ_�D�7���P�FZ��{�\܊�LV���b�k8�E�$�Kօ:�~�*6��Ƥa�.�5}aW�\�i\>��6�t7d�QUR@b���e�憦i�w:��Ҧ�.�V΃��vlZ�K3�|����%j�������.k�@4�R�q�$�D�6KwI�ˌ�̠�� ����Z��-|�'���h,Df�l��bŮrqk���Lo����B�����(����!l��,9���۽�C��FUhws�ݷ\�\^\*��{_�ۗW�Q�r��)H�$���69z)®���S��g���S@"+`M����E\VX3 {��Tv)v�f(]G�e�2B|�z���D�ǣ]���^;U�/���!�=O;Ϯ����ܲ���e^��\V�_G�;�5�>�]~�m� �zT���7o+�u䄑T���o���Oj�{�j�$�`JH��v�wݐ�z���6A���!)�ڔ��Քymʲ��D�Z	����;1m^�o���2�=��$<���<�O�-9l��ģ��w�j������r��v���}{���I���9��Ŕ�]�+$X��Y��f_B${:��m�Π������w���M�.�� ȱ��uا���EL��F��'8�7��"��~�X�*��A��,ŌkY7�.�`�#���f�|L���+����j��ď�om97+.�>ޛ5T>8j�5�N-�]�#�9��ϽN}���[c��bu(�ɾ������1�� i�S�^��t���ۭ�ʹW���ߣZK���
�]a�4�:�vW5�	��SI�2dȐ!C�����Uq� (  