#pragma once

#include <iostream>
#include <fstream>
#include <vector>

namespace garden {

class Seqfile {
public:
    static bool write_pair(const std::string& key, const std::string& value, std::FILE* stream) {
        // 一组数据：| k_len | key | v_len | value |
        // 数字全部转小端，统一读写方式。字符串作为字节流不需要转换，以原bytes输出。
        uint32_t k_len = to_little_endian(key.size());
        std::size_t write_size = std::fwrite(reinterpret_cast<char*>(&k_len), sizeof(uint32_t), 1, stream);
        if (write_size < 1) {
            // std::size_t fwrite(const void* buffer, std::size_t size, std::size_t count, std::FILE* stream);
            // Number of objects written successfully, which may be less than count if an error occurred.
            std::cerr << "key size write failed" << std::endl;
            return false;
        }
        write_size = std::fwrite(key.c_str(), key.size(), 1, stream);
        if (write_size < 1) {
            std::cerr << "key write failed" << std::endl;
            return false;
        }

        uint32_t v_len = to_little_endian(value.size());
        std::fwrite(reinterpret_cast<char*>(&v_len), sizeof(uint32_t), 1, stream);
        if (write_size < 1) {
            std::cerr << "value size write failed" << std::endl;
            return false;
        }
        std::fwrite(value.c_str(), value.size(), 1, stream);
        if (write_size < 1) {
            std::cerr << "value write failed" << std::endl;
            return false;
        }
        return true;
    }

    static bool read_pair(std::string& key, std::string& value, std::FILE* stream) {
        uint32_t k_len = 0;
        std::size_t read_size = std::fread(reinterpret_cast<char*>(&k_len), sizeof(uint32_t), 1, stream);
        if (read_size < 1) {
            // 读结束
            // Number of objects read successfully, which may be less than count if an error or end-of-file condition occurs.
            return false;
        }
        k_len = to_little_endian(k_len);
        key.resize(k_len, '\0');
        read_size = std::fread(&key[0], k_len, 1, stream);
        if (read_size < 1) {
            std::cerr << "key read failed" << std::endl;
            return false;
        }

        uint32_t v_len = 0;
        read_size = std::fread(reinterpret_cast<char*>(&v_len), sizeof(uint32_t), 1, stream);
        if (read_size < 1) {
            std::cerr << "value size read failed" << std::endl;
            return false;
        }
        v_len = to_little_endian(v_len);
        value.resize(v_len, '\0');
        read_size = std::fread(&value[0], v_len, 1, stream);
        if (read_size < 1) {
            std::cerr << "value read failed" << std::endl;
            return false;
        }

        return true;
    }

    static bool is_big_endian() {
        union {
            uint32_t i;
            uint8_t c[4];
        } test = { 0x01020304 };

        return test.c[0] == 1;
    }

    static uint32_t to_little_endian(uint32_t i) {
        static bool big_endian = is_big_endian();
        if (big_endian) {
            return __builtin_bswap32(i);
        }
        return i;
    }
};

} // namespace garden
