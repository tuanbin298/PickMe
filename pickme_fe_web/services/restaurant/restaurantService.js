import axios from "axios";

const API_URL = import.meta.env.VITE_API_URL;

const restaurantService = {
  // API get pending restaurant
  getPendingRestaurants: async (token) => {
    try {
      const { data } = await axios.get(
        `${API_URL}  /admin/restaurants/pending`,
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

  // API get all restaurants
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

  // API prove restaurant
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

  // API reject restaurant
  rejectRestaurant: async (id, reason, token) => {
    try {
      const { data } = await axios.post(
        `${API_URL}/admin/restaurants/${id}/reject?reason=${encodeURIComponent(
          reason
        )}`,
        {},
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
