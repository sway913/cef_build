## 第一参数为上面要修改的#define 的文件路径，第二参数为 F:\cef\source\chromium\src\third_party\ffmpeg\chromium\config\Chrome\win\ia32\config.h
import sys
import shutil
import re
import os
 
def Replace(change,content):
   str_array = re.findall("#define\s\w+\s",change)
   str_replace =str_array[0]
   str_replace+="0"
   str_dest =str_array[0]
   str_dest+="1"
   return content.replace(str_replace,str_dest)
 
if len(sys.argv) > 2 :
   src_file_name =sys.argv[1]
   dest_file_name=sys.argv[2]
else:
   src_file_name =raw_input("Please input src file path name:").replace("\r","")
   dest_file_name =raw_input("Please input dest file path name:").replace("\r","")
 
 
file_src_handle = open(src_file_name,"r")
file_src_lines = file_src_handle.readlines()
file_src_handle.close()
file_dest_handle = open(dest_file_name,"r")
dest_file_content = file_dest_handle.read()
file_dest_handle.close()
 
for line in file_src_lines:
    dest_file_content = Replace(line,dest_file_content)
 
write_file_path = os.getcwd()+"\\"+ os.path.basename(dest_file_name)
ready_copy = open(write_file_path,"w")
ready_copy.write(dest_file_content)
ready_copy.close()
 
shutil.copy(write_file_path,dest_file_name)
os.remove(write_file_path)

print("---Support mp4 Success!!!")