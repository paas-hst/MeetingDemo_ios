#pragma once

#include <stdio.h>
#include <string.h>

#include <map>
#include <string>

#include "aes.h"

namespace fsp {
namespace tools {

static const char base64_chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                   "abcdefghijklmnopqrstuvwxyz"
                                   "0123456789+/";

inline char *base64_encode(const unsigned char *input, int length) {
  /* http://www.adp-gmbh.ch/cpp/common/base64.html */
  int i = 0, j = 0, s = 0;
  unsigned char char_array_3[3], char_array_4[4];

  int b64len = (length + 2 - ((length + 2) % 3)) * 4 / 3;
  char *b64str = new char[b64len + 1];

  while (length--) {
    char_array_3[i++] = *(input++);
    if (i == 3) {
      char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
      char_array_4[1] =
          ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
      char_array_4[2] =
          ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
      char_array_4[3] = char_array_3[2] & 0x3f;

      for (i = 0; i < 4; i++)
        b64str[s++] = base64_chars[char_array_4[i]];

      i = 0;
    }
  }
  if (i) {
    for (j = i; j < 3; j++)
      char_array_3[j] = '\0';

    char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
    char_array_4[1] =
        ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
    char_array_4[2] =
        ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
    char_array_4[3] = char_array_3[2] & 0x3f;

    for (j = 0; j < i + 1; j++)
      b64str[s++] = base64_chars[char_array_4[j]];

    while (i++ < 3)
      b64str[s++] = '=';
  }
  b64str[b64len] = '\0';

  return b64str;
}

inline bool is_base64(unsigned char c) {
  return (isalnum(c) || (c == '+') || (c == '/'));
}

inline unsigned char *base64_decode(const char *input, int length,
                                    int *outlen) {
  int i = 0;
  int j = 0;
  int r = 0;
  int idx = 0;
  unsigned char char_array_4[4], char_array_3[3];
  unsigned char *output = new unsigned char[length * 3 / 4];

  while (length-- && input[idx] != '=') {
    // skip invalid or padding based chars
    if (!is_base64(input[idx])) {
      idx++;
      continue;
    }
    char_array_4[i++] = input[idx++];
    if (i == 4) {
      for (i = 0; i < 4; i++)
        char_array_4[i] = strchr(base64_chars, char_array_4[i]) - base64_chars;

      char_array_3[0] =
          (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
      char_array_3[1] =
          ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
      char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

      for (i = 0; (i < 3); i++)
        output[r++] = char_array_3[i];
      i = 0;
    }
  }

  if (i) {
    for (j = i; j < 4; j++)
      char_array_4[j] = 0;

    for (j = 0; j < 4; j++)
      char_array_4[j] = strchr(base64_chars, char_array_4[j]) - base64_chars;

    char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
    char_array_3[1] =
        ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
    char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

    for (j = 0; (j < i - 1); j++)
      output[r++] = char_array_3[j];
  }

  *outlen = r;

  return output;
}

inline std::string AesCbcEncBase64(const std::string &content,
                                   const std::string &strKey) {
  if (content.empty() || strKey.empty()) {
    return std::string("");
  }

  struct AES_ctx ctx;
  uint8_t *in_buffer = new uint8_t[content.size()];
  for (std::string::size_type i = 0; i < content.size(); i++) {
    in_buffer[i] = (uint8_t)content[i];
  }

  uint8_t iv[] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                  0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
  AES_init_ctx_iv(&ctx, (uint8_t *)strKey.data(), iv);
  AES_CBC_encrypt_buffer(&ctx, in_buffer, content.length());

  char *rBase64 = base64_encode(in_buffer, content.length());

  std::string res = (const char *)rBase64;

  delete[] in_buffer;
  delete[] rBase64;

  return res;
}

inline std::string AesCbcDecBase64(const std::string &content,
                                   const std::string &strKey) {  
  struct AES_ctx ctx;

  int nEncryptedLen = 0;
  uint8_t *szEncryptedData =
      base64_decode(content.data(), content.length(), &nEncryptedLen);

  uint8_t iv[] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                  0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
  AES_init_ctx_iv(&ctx, (uint8_t *)strKey.data(), iv);
  AES_CBC_decrypt_buffer(&ctx, szEncryptedData, nEncryptedLen);

  std::string textContent;

  for (int i = 0; i < nEncryptedLen; i++) {
    textContent.append(1, szEncryptedData[i]);
  }

  delete[] szEncryptedData;

  return textContent;
}

inline std::string base64Encode(const std::string &data) {
  char *r = base64_encode((const unsigned char *)data.data(), data.length());
  std::string s(r);
  delete[] r;
  return s;
}

inline std::string base64Decode(const std::string &data) {
  int length = 0;
  const unsigned char *r = base64_decode(data.data(), data.length(), &length);
  std::string s((const char *)r, (size_t)length);
  delete[] r;
  return s;
}

} // namespace tools
} // namespace fsp
