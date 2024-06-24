#!/bin/bash

# 스크립트 실행 시 인자로 volumelist 파일을 입력받음
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <volumelist_file>"
    exit 1
fi

volumelist_file="$1"

# volumelist 파일이 존재하는지 확인
if [ ! -f "$volumelist_file" ]; then
    echo "Error: $volumelist_file not found."
    exit 1
fi

# volumelist 파일에서 한 줄씩 읽어서 처리
while IFS= read -r subvolume_name; do
    # subvolume_name 변수가 비어있으면 다음 줄로 넘어감
    if [ -z "$subvolume_name" ]; then
        continue
    fi

    # subvolumegroup 입력 받기
    read -p "Enter subvolumegroup for $subvolume_name (dev, sandbox, qa): " subvolumegroup

    # size 입력 받기
    read -p "Enter size for $subvolume_name (numeric value): " size

    # 입력된 size에 1024의 3제곱을 곱하여 계산
    size=$(( size * 1024 * 1024 * 1024 ))

    # ceph 명령 실행
    echo "ceph fs subvolume create nfsroot $subvolume_name $subvolumegroup $size"
done < "$volumelist_file"
