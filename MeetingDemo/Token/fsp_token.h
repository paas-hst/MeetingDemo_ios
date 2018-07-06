#pragma once

#include <iostream>
#include <map>
#include <string>
#include <random>
#include <chrono>

#include "fsp_tools.h"

namespace fsp
{
namespace tools
{

static const std::string kPrivilegeJoinGroup = "jg";
static const std::string kPrivilegePublishVideo = "pv";
static const std::string kPrivilegePublishAudio = "pa";

class AccessToken
{

  public:
	AccessToken(const std::string &appSecretKey);

	std::string Version();

	std::string Build();
	std::string ParseToJson(const std::string &token);

	std::string app_id;
	std::string group_id;
	std::string user_id;
	uint32_t expire_time;

  private:
	std::string secret_key_;
	std::string version_;
};

AccessToken::AccessToken(const std::string &appSecretKey)
{
	version_ = "001";
	secret_key_ = appSecretKey;
	expire_time = 0;
}

std::string AccessToken::Version()
{
	return version_;
}

std::string AccessToken::Build()
{
	if (secret_key_.length() != 16) {
		std::cout << "key error" << std::endl;
        return std::string("");
    }

	//simple string build,  you can use your json library

	std::string rawContent("{");

	rawContent.append("\"aid\":\"").append(app_id).append("\",");
	rawContent.append("\"gid\":\"").append(group_id).append("\",");
	rawContent.append("\"uid\":\"").append(user_id).append("\",");

	if (expire_time != 0)
	{
		rawContent.append("\"et\":").append(std::to_string(expire_time)).append(",");
	}

	auto nowpt = std::chrono::system_clock::now();
	auto mspt = std::chrono::duration_cast<std::chrono::milliseconds>(nowpt.time_since_epoch());
	unsigned long msTime = mspt.count();
	rawContent.append("\"ts\":").append(std::to_string(msTime)).append(",");

	std::random_device r;
	rawContent.append("\"r\":").append(std::to_string(r()));

	rawContent.append("}");

	if (rawContent.size() % 16 != 0)
	{
		//长度不够16倍数， 补空格
		rawContent.append(16 - (rawContent.size() % 16), ' ');
	}
	
	std::string encrtyped = AesCbcEncBase64(rawContent, secret_key_);

	return version_ + encrtyped;
}

std::string AccessToken::ParseToJson(const std::string &token)
{
	//3 is version str size
	if (token.size() < 3 || secret_key_.length() != 16)
	{
		std::cout << "token or key error" << std::endl;
		return std::string("");
	}

	version_ = token.substr(0, 3);
	std::string strTokenContent = token.substr(3);

	strTokenContent = AesCbcDecBase64(strTokenContent, secret_key_);

	return strTokenContent;
}

} // namespace tools
} // namespace fsp
