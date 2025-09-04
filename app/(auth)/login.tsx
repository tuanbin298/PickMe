import { images } from "@/constants/images";
import { Ionicons } from "@expo/vector-icons";
import { Link, useRouter } from "expo-router";
import { useState } from "react";
import {
  Image,
  KeyboardAvoidingView,
  Platform,
  SafeAreaView,
  ScrollView,
  StatusBar,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

export default function Login() {
  const router = useRouter();
  const [showPassword, setShowPassword] = useState(false);

  return (
    <SafeAreaView className="flex-1 bg-white">
      <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />

      {/* Keyboard Avoiding View */}
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        className="flex-1"
      >
        <ScrollView
          contentContainerStyle={{ flexGrow: 1 }}
          keyboardShouldPersistTaps="handled"
        >
          {/* Logo */}
          <View className="items-center mt-20">
            <Image
              source={images.pickme_logo}
              style={{ width: 250, height: 120, resizeMode: "contain" }}
            />
          </View>

          {/* Content */}
          <View className="flex-1 mt-5 px-8">
            {/* Welcome text */}
            <Text className="text-center text-2xl font-bold text-gray-900">
              Chào mừng bạn
            </Text>
            <Text className="text-center text-gray-500 mt-1 leading-7">
              Đăng nhập để tiếp tục {"\n"}Hoặc{" "}
              <Link href="/register" asChild>
                <Text className="text-orange-500">Tạo tài khoản</Text>
              </Link>
            </Text>

            {/* Form */}
            <View className="mt-8">
              <TextInput
                placeholder="Email"
                placeholderTextColor="#9ca3af"
                className="border border-gray-400 rounded-lg px-4 py-3 mb-4"
              />

              {/* Password input */}
              <View className="flex-row items-center border border-gray-400 rounded-lg px-4">
                <TextInput
                  placeholder="Mật khẩu"
                  placeholderTextColor="#9ca3af"
                  secureTextEntry={!showPassword}
                  className="flex-1 py-3"
                />
                <TouchableOpacity
                  onPress={() => setShowPassword(!showPassword)}
                >
                  <Ionicons
                    name={showPassword ? "eye-off" : "eye"}
                    size={22}
                    color="#9ca3af"
                  />
                </TouchableOpacity>
              </View>

              {/* Button */}
              <TouchableOpacity className="w-full bg-[#fc7f20] py-3 rounded-lg mb-9 mt-5">
                <Text className="text-center text-white font-semibold text-lg">
                  Đăng nhập
                </Text>
              </TouchableOpacity>

              {/* Forget password */}
              <Text className="text-center text-[#fc7f20] mb-6">
                Quên mật khẩu?
              </Text>

              {/* Separator */}
              <View className="flex-row items-center my-6">
                <View className="flex-1 h-[1px] bg-gray-300" />
                <Text className="mx-3 text-gray-400">hoặc</Text>
                <View className="flex-1 h-[1px] bg-gray-300" />
              </View>

              {/* Đăng nhập bằng Google */}
              <TouchableOpacity className="w-full border border-gray-300 py-3 rounded-lg flex-row justify-center items-center">
                <Image source={images.google_logo} className="w-6 h-6 mr-2" />
                <Text className="text-gray-700">Đăng nhập bằng Google</Text>
              </TouchableOpacity>
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
