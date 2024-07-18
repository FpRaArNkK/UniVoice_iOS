#!/bin/sh

# ci_post_clone.sh
# UniVoice
#
# Created by 박민서 on 7/18/24.
#
#!/bin/sh

# 환경변수를 사용하여 UniVoiceConfig.xcconfig 파일 생성
echo "환경변수 참조 UniVoiceConfig.xcconfig 파일 생성 시작"

# Xcode Cloud 작업 공간 디렉토리 설정
FOLDER_PATH="$CI_WORKSPACE/UniVoice/Global/Utility"

# 경로가 존재하지 않을 경우 생성
mkdir -p "$FOLDER_PATH"

# 환경변수 값을 포함한 파일 생성
cat <<EOF > "$FOLDER_PATH/UniVoiceConfig.xcconfig"
BASE_URL = ${BASE_URL}
EOF

echo "환경변수 참조 UniVoiceConfig.xcconfig 파일 생성 완료"
