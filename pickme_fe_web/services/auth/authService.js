import axios from "axios";

const API_URL = import.meta.env.VITE_API_URL;

const authService = {
  login: async (email, password) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/auth/login`,
        { email, password },
        {
          headers: { "Content-Type": "application/json" },
        }
      );

      return data;
    } catch (error) {
      throw error.response?.data || { message: "Lỗi kết nối server" };
    }
  },
};

export default authService;
