import axios from "axios";

const API_URL = import.meta.env.VITE_API_URL;

const authService = {
  // API login
  login: async (email, password) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/auth/login`,
        { email, password },
        { headers: { "Content-Type": "application/json" } }
      );
      return data;
    } catch (error) {
      throw error.response?.data || { message: "Lỗi kết nối server" };
    }
  },

  // API send OTP
  sendOtp: async (email, token) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/auth/send-otp`,
        { email },
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );
      return data;
    } catch (error) {
      throw error.response?.data || { message: "Lỗi kết nối server" };
    }
  },

  // API verify OTP
  verifyOtp: async (email, otp, token) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/auth/verify-otp`,
        { email, otp },
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );
      return data;
    } catch (error) {
      throw error.response?.data || { message: "OTP không hợp lệ" };
    }
  },

  // API reset password
  resetPassword: async (email, otp, newPassword, token) => {
    try {
      const payload = {
        email,
        otp,
        newPassword,
        confirmPassword: newPassword,
        passwordsMatch: true,
      };
      const { data } = await axios.post(
        `${API_URL}/auth/reset-password-with-otp`,
        payload,
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );
      return data;
    } catch (error) {
      throw error.response?.data || { message: "Đặt lại mật khẩu thất bại" };
    }
  },
};

export default authService;
