print_ok() {
  echo -e "\e[32m\xE2\x9C\x94 $1 \e[0m"
  echo
}

print_process() {
  echo -e "\e[36m- $1 \e[0m"
}

print_info() {
  echo -e "\e[34m$1 \e[0m"
}

