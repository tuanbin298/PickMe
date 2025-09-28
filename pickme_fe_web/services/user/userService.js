import axios from "axios";

const API_URL = import.meta.env.VITE_API_URL;

const userService = {
  getAllUsers: async (token) => {
    try {
      const { data } = await axios.get(`${API_URL}/users`, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      });

      return data;
    } catch (error) {
      throw error.response?.data || { message: "Lỗi kết nối server" };
    }
  },
};

export default userService;
