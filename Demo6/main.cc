// Copyright (c) [2022-2023] [Martin King][MT].
//
// You can use this software according to the terms and conditions of
// the Apache v2.0.
// You may obtain a copy of Apache v2.0. at:
//
//     http: //www.apache.org/licenses/LICENSE-2.0
//
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See Apache v2.0 for more details.

// @author MT
// @date   2023-01-28

#include <iostream>

// Thrid parties
#include <spdlog/spdlog.h>

#include <nlohmann/json.hpp>

using json = nlohmann::json;
int main() {
  json object = {{"one", 1}, {"two", 2}};
  json null;

  std::cout << object.dump(2) << '\n';
  std::cout << null.dump(2) << '\n';

  auto res1 = object.emplace("three", 3);
  null.emplace("A", "a");
  null.emplace("B", "b");

  // the following call will not add an object, because there is already
  // a value stored at key "B"
  auto res2 = null.emplace("B", "c");

  std::cout << object.dump(2) << '\n';
  std::cout << *res1.first << " " << std::boolalpha << res1.second << '\n';
  std::cout << *res2.first << " " << std::boolalpha << res2.second << '\n';
  std::cout << null.dump(2) << '\n';

  // spdlog test
  spdlog::info("Hello spdlog!");
  return 0;
}
