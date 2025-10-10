import axios from "axios";

const API_URL = import.meta.env.VITE_API_URL;

const restaurantService = {
  // ✅ Lấy danh sách quán đang chờ duyệt
  getPendingRestaurants: async (token) => {
    try {
      const { data } = await axios.get(`${API_URL}/admin/restaurants/pending`, {
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

  // ✅ Lấy tất cả quán
  getAllRestaurants: async (token) => {
    try {
      const { data } = await axios.get(`${API_URL}/admin/restaurants`, {
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

  // ✅ Duyệt quán
  approveRestaurant: async (id, token) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/admin/restaurants/${id}/approve`,
        {}, // không có body
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

  // ✅ Từ chối quán
  rejectRestaurant: async (id, reason, token) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/admin/restaurants/${id}/reject?reason=${encodeURIComponent(
          reason
        )}`,
        {}, // không có body
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
};

export default restaurantService;
