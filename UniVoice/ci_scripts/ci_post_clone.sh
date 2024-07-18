#!/bin/sh

#  ci_post_clone.sh
#  UniVoice
#
#  Created by 박민서 on 7/18/24.
#
# Secrets.xcconfig 파일 생성
echo "환경변수 참조 UniVoiceConfig.xcconfig file 생성시작"
# Secrets 경로 지정
cat <<EOF > "/Volumes/workspace/repository/UniVoice/Global/Utility/UniVoiceConfig.xcconfig"
BASE_URL = $(BASE_URL)
EOF

echo "환경변수 참조 UniVoiceConfig.xcconfig file 생성완료"
