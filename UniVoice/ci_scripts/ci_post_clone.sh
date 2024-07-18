#!/bin/sh

# ci_post_clone.sh
# UniVoice
#
# Created by 박민서 on 7/18/24.
#
# Secrets.xcconfig 파일 생성
echo "환경변수 참조 UniVoiceConfig.xcconfig file 생성시작"

# Xcode Cloud 작업 공간 디렉토리 설정
FOLDER_PATH="$CI_WORKSPACE/UniVoice/Global/Utility"

# 경로가 존재하지 않을 경우 생성
if [ ! -d "$FOLDER_PATH" ]; then
  mkdir -p "$FOLDER_PATH"
fi

# Secrets 경로 지정 및 환경변수 값을 포함한 파일 생성
cat <<EOF > "$FOLDER_PATH/UniVoiceConfig.xcconfig"
BASE_URL = ${BASE_URL}
EOF

echo "환경변수 참조 UniVoiceConfig.xcconfig file 생성완료"

# 생성된 파일 내용 출력
echo "생성된 파일 내용:"
cat "$FOLDER_PATH/UniVoiceConfig.xcconfig"
