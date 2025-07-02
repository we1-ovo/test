#!bin/bash

# 找到 GenRPG 目录下的所有 .lua 文件
lua_files=$(find GenRPG -type f -name "*.lua")
# 如果没有找到任何文件，输出提示信息
if [ -z "$lua_files" ]; then
	  echo "No lua files found."
	  exit 1
fi
echo "Processing all lua files begin."

# 遍历每个文件
for file in $lua_files; do
  # 去掉文件名的后缀，同时保留路径
  filename="${file%.*}"
  echo "Processing file: $filename"
  lua ./lua_check/main.lua "$filename"
done
echo "Processing all lua files done."
