import { useRouter } from "expo-router";
import { Text, View } from "react-native";

export default function Register() {
  const router = useRouter();

  return (
    <View className="flex-1 items-center justify-center bg-primary">
      <Text className="text-white text-xl mb-5">Register Screen</Text>
    </View>
  );
}
