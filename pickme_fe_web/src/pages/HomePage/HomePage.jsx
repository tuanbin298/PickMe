import { Link } from "react-router-dom";
import { Divider } from "@mui/material";
import images from "../../../constants/images";
import { People, Store, BarChart, Security } from "@mui/icons-material";

export default function Homepage() {
  return (
    <div className="bg-gray-50">
      {/* Hero Section */}
      <section
        className="bg-white text-white py-28 px-4"
        style={{
          backgroundImage: `url(${images.background})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
      >
        <div className="container mx-auto text-center">
          {/* Small blur background */}
          <div className="inline-block bg-black/50 backdrop-blur-sm px-8 py-6 rounded-xl text-white">
            <h1 className="text-5xl font-extrabold mb-4">
              Trang quản trị <span className="text-orange-500">PickMe</span>
            </h1>

            <p className="mb-8 text-lg md:text-xl text-extrabold-200">Kiểm soát toàn bộ hệ thống, theo dõi dữ liệu và quản lý hoạt động của quán ăn trong nền tảng.</p>

            {/* Action buttons */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              {/* Login btn */}
              <Link to="/login" className="px-8 py-3 bg-orange-500 text-white font-semibold rounded-xl hover:bg-orange-600 transition">
                Đăng nhập quản trị
              </Link>

              {/* Download APK btn */}
              <a
                href="https://drive.google.com/file/d/1nUDx6Bo0m8aF60cJpnZy9RuL7e6GRQ7Z/view?usp=drive_link"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-3 bg-blue-500 text-white font-semibold rounded-xl hover:bg-blue-600 transition flex items-center gap-2"
              >
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                  <path
                    fillRule="evenodd"
                    d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"
                    clipRule="evenodd"
                  />
                </svg>
                Tải PickMe trên Android
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* About PickMe Section */}
      <section className="py-20 px-4 bg-gray-50">
        <div className="container mx-auto flex flex-col md:flex-row items-center gap-12">
          {/* Left */}
          <div className="md:w-5/12 text-center md:text-left ml-40">
            <h2 className="text-4xl font-bold mb-4">
              Giới thiệu về <span className="text-orange-500 font-extrabold">PickMe</span>
            </h2>
            <p className="text-gray-700 mb-4 text-lg">PickMe là nền tảng quản trị giúp bạn dễ dàng theo dõi dữ liệu, quản lý người dùng, quán ăn và đơn hàng. Tất cả trong một giao diện trực quan, hiện đại.</p>
            <p className="text-gray-700 text-lg">Với hệ thống báo cáo thống kê chi tiết, bạn có thể nắm bắt hiệu quả hoạt động, ra quyết định nhanh chóng và chính xác hơn.</p>
          </div>

          {/* Right */}
          <div className="md:w-1/2">
            <img src={images.foodImage} alt="PickMe admin dashboard" className="w-3/4 md:w-2/3 mx-auto rounded-xl shadow-lg" />
          </div>
        </div>
      </section>

      {/* Divider */}
      <Divider
        sx={{
          my: 4,
          width: "75%",
          mx: "auto",
          borderColor: "grey.500",
        }}
      />

      {/* Features Section */}
      <section className="py-20 px-4">
        <div className="container mx-auto text-center">
          <h2 className="text-3xl font-bold mb-12">Chức năng dành cho Admin</h2>

          <div className="flex justify-center gap-8">
            {/* Card manage user */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <People className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Quản lý người dùng</h3>
              <p className="text-gray-600">Theo dõi, chỉnh sửa và phân quyền người dùng trên hệ thống.</p>
            </div>

            {/* Card manage store */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <Store className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Quản lý quán ăn</h3>
              <p className="text-gray-600">Duyệt, kích hoạt hoặc khóa quán ăn khi cần thiết.</p>
            </div>

            {/* Card dashboard */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <BarChart className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Báo cáo thống kê</h3>
              <p className="text-gray-600">Xem dữ liệu tổng hợp về người dùng, doanh thu, hiệu quả hoạt động.</p>
            </div>

            {/* Card security, role */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <Security className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Bảo mật & Phân quyền</h3>
              <p className="text-gray-600">Quản lý vai trò admin, đảm bảo an toàn và kiểm soát truy cập.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Divider */}
      <Divider
        sx={{
          my: 4,
          width: "75%",
          mx: "auto",
          borderColor: "grey.500",
        }}
      />

      {/* Mobile App Download Section */}
      <section className="py-20 px-4 bg-gradient-to-r from-blue-500 to-purple-600">
        <div className="container mx-auto text-center">
          <div className="bg-white/90 backdrop-blur-sm px-8 py-12 rounded-2xl shadow-xl max-w-4xl mx-auto">
            <h2 className="text-4xl font-bold mb-6 text-gray-800">
              📱 Tải ứng dụng <span className="text-orange-500">PickMe</span> Mobile
            </h2>

            <p className="text-lg text-gray-600 mb-8 max-w-2xl mx-auto">Trải nghiệm đặt món và quản lý quán ăn ngay trên điện thoại của bạn. Giao diện thân thiện, tính năng đầy đủ, hoạt động mượt mà.</p>

            <div className="flex flex-col sm:flex-row gap-6 justify-center items-center">
              {/* Download APK Button */}
              <a
                href="https://drive.google.com/file/d/1nUDx6Bo0m8aF60cJpnZy9RuL7e6GRQ7Z/view?usp=drive_link"
                target="_blank"
                rel="noopener noreferrer"
                className="bg-gradient-to-r from-green-500 to-blue-500 text-white px-10 py-4 rounded-2xl font-bold text-lg hover:from-green-600 hover:to-blue-600 transform hover:scale-105 transition-all duration-300 shadow-lg flex items-center gap-3"
              >
                <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                  <path
                    fillRule="evenodd"
                    d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"
                    clipRule="evenodd"
                  />
                </svg>
                Tải PickMe trên Android
              </a>

              {/* Features list */}
              <div className="text-left text-gray-700">
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-green-500">✓</span>
                  <span>Đặt món nhanh chóng</span>
                </div>
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-green-500">✓</span>
                  <span>Quản lý quán ăn</span>
                </div>
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-green-500">✓</span>
                  <span>Thanh toán tiện lợi</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="text-green-500">✓</span>
                  <span>Theo dõi đơn hàng</span>
                </div>
              </div>
            </div>

            {/* Installation note */}
            <div className="mt-8 p-4 bg-yellow-100 rounded-lg border-l-4 border-yellow-500">
              <p className="text-sm text-yellow-800">
                <strong>Lưu ý:</strong> Cần bật "Cài đặt từ nguồn không xác định" trong cài đặt Android để cài APK.
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
