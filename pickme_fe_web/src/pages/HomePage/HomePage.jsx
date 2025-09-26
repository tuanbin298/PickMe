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

            <p className="mb-8 text-lg md:text-xl text-extrabold-200">
              Kiểm soát toàn bộ hệ thống, theo dõi dữ liệu và quản lý hoạt động
              của quán ăn trong nền tảng.
            </p>

            {/* Login btn */}
            <Link
              to="/login"
              className="px-8 py-3 bg-orange-500 text-white font-semibold rounded-xl hover:bg-orange-600 transition"
            >
              Đăng nhập quản trị
            </Link>
          </div>
        </div>
      </section>

      {/* About PickMe Section */}
      <section className="py-20 px-4 bg-gray-50">
        <div className="container mx-auto flex flex-col md:flex-row items-center gap-12">
          {/* Left */}
          <div className="md:w-5/12 text-center md:text-left ml-40">
            <h2 className="text-4xl font-bold mb-4">
              Giới thiệu về{" "}
              <span className="text-orange-500 font-extrabold">PickMe</span>
            </h2>
            <p className="text-gray-700 mb-4 text-lg">
              PickMe là nền tảng quản trị giúp bạn dễ dàng theo dõi dữ liệu,
              quản lý người dùng, quán ăn và đơn hàng. Tất cả trong một giao
              diện trực quan, hiện đại.
            </p>
            <p className="text-gray-700 text-lg">
              Với hệ thống báo cáo thống kê chi tiết, bạn có thể nắm bắt hiệu
              quả hoạt động, ra quyết định nhanh chóng và chính xác hơn.
            </p>
          </div>

          {/* Right */}
          <div className="md:w-1/2">
            <img
              src={images.foodImage}
              alt="PickMe admin dashboard"
              className="w-3/4 md:w-2/3 mx-auto rounded-xl shadow-lg"
            />
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
              <p className="text-gray-600">
                Theo dõi, chỉnh sửa và phân quyền người dùng trên hệ thống.
              </p>
            </div>

            {/* Card manage store */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <Store className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Quản lý quán ăn</h3>
              <p className="text-gray-600">
                Duyệt, kích hoạt hoặc khóa quán ăn khi cần thiết.
              </p>
            </div>

            {/* Card dashboard */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <BarChart className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">Báo cáo thống kê</h3>
              <p className="text-gray-600">
                Xem dữ liệu tổng hợp về người dùng, doanh thu, hiệu quả hoạt
                động.
              </p>
            </div>

            {/* Card security, role */}
            <div
              className="bg-white shadow-lg rounded-xl p-6 flex flex-col items-center w-full md:w-1/3 lg:w-1/4
            cursor-pointer transform transition duration-300 hover:-translate-y-2 hover:shadow-2xl"
            >
              <Security className="text-orange-500 w-12 h-12 mb-4" />
              <h3 className="text-xl font-semibold mb-2">
                Bảo mật & Phân quyền
              </h3>
              <p className="text-gray-600">
                Quản lý vai trò admin, đảm bảo an toàn và kiểm soát truy cập.
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
