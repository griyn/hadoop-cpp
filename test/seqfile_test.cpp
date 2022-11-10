#include "seqfile.h"
#include <iostream>

int main() {
    FILE* fp = std::fopen("test.txt", "w+");
    if(!fp) {
        std::perror("File opening failed");
        return 1;
    }

    std::string key = "Tom";
    std::string value = "value of Tom";
    garden::Seqfile::write_pair(key, value, fp);

    key = "Jack";
    value = "value of Jack";
    garden::Seqfile::write_pair(key, value, fp);

    std::fclose(fp); // 这里需要关闭fd才能再读到数据

    FILE* rf = std::fopen("test.txt", "r");
    while (garden::Seqfile::read_pair(key, value, rf)) {
        std::cout << key << "\t" << value << std::endl;
    }

    std::fclose(rf);

    return 0;
}
