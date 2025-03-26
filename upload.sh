#!/bin/bash

# 设置getCategories.py的绝对路径
PYTHON_CATEGORIES_PATH="/Users/User/Desktop/pycnblog/getCategories.py"
# 设置upload_markdown.py的绝对路径
PYTHON_UPLOAD_PATH="/Users/User/Desktop/pycnblog/upload_markdown.py"

# &> /dev/null：重定向并丢弃，避免将检测结果输出在终端，
# 检查是否安装了 Python
if  ! command -v python3 &> /dev/null;then
    echo "Python3 未安装，请安装 Python3。"
    exit 1
fi

# 检查是否安装了 pip
if  ! command -v pip3 &> /dev/null;then
    echo "pip3 未安装，请安装 pip3。"
    exit 1
fi

# 检查是否安装了所需的 Python 包
REQUIRED_PKG="pyyaml"
for PKG in $REQUIRED_PKG; do
    if ! pip3 show $PKG &> /dev/null; then
        echo "$PKG 未安装，正在安装..."
        pip3 install $PKG
    fi
done

# 检测是否配置了Python脚本路径
if [ -z $PYTHON_UPLOAD_PATH ];then
  echo "未配置upload_markdown.py脚本路径"
  exit 0
fi

if [ -z $PYTHON_CATEGORIES_PATH ];then
  echo "未配置getCategories.py脚本路径"
  exit 0
fi



while true; do
  # read：按行读取，可以一次性读取多个值；参数p：读入字符串之前，打印的提示字符串；
    read -p  "Please input file path: " filePath
    python "$PYTHON_CATEGORIES_PATH"
    read -p  "Please input categories (separated by space): " category
    python "$PYTHON_UPLOAD_PATH" "$filePath" "$category"
    status=$?
    if [ $status -eq 0 ];then
      echo "Uploading success"
      break
    else
      echo "Uploading fail"
    fi
done