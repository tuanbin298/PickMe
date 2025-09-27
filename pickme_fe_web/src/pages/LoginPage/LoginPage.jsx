import { useState } from "react";
import images from "../../../constants/images";
import VisibilityIcon from "@mui/icons-material/Visibility";
import VisibilityOffIcon from "@mui/icons-material/VisibilityOff";
import {
  Button,
  CircularProgress,
  IconButton,
  InputAdornment,
  TextField,
} from "@mui/material";
import authService from "../../../services/auth/authService";
import { toast } from "react-toastify";

export default function LoginPage() {
  // State
  const [input, setInput] = useState({
    email: "",
    password: "",
  });
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState({});

  // Function change state of input
  const handleInputChange = (e) => {
    // Name of input, value of input
    const { name, value } = e.target;
    setInput({
      ...input,
      [name]: value,
    });

    // Validate input
    let newErrors = { ...errors };

    if (name === "email") {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      newErrors.email = emailRegex.test(value) ? "" : "Email không hợp lệ!";
    }

    if (name === "password") {
      newErrors.password =
        value.length >= 6 ? "" : "Mật khẩu phải có ít nhất 6 ký tự!";
    }

    setErrors(newErrors);
  };

  // Logic submit
  const handleSubmit = async (e) => {
    e.preventDefault();

    // Check for validation errors
    if (Object.values(errors).some((error) => error)) {
      toast.error("Vui lòng kiểm tra lại thông tin!");
      return;
    }

    setLoading(true);

    // Call API
    try {
      const data = await authService.login(input.email, input.password);

      // Save data to localStorage
      localStorage.setItem("sessionToken", data.token);
      localStorage.setItem("id", data.id);
      localStorage.setItem("email", data.email);
      localStorage.setItem("fullName", data.fullName);
      localStorage.setItem("role", data.role);
      localStorage.setItem("phoneNumber", data.phoneNumber);
      localStorage.setItem("imageUrl", data.imageUrl);

      toast.success("Đăng nhập thành công");
    } catch (error) {
      toast.error(
        "Đăng nhập thất bại: " + (error.message || "Lỗi kết nối server")
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      className="min-h-screen flex items-center justify-center 
                bg-gradient-to-br from-orange-500 via-orange-400 to-orange-600 px-4"
    >
      <div className="flex w-full max-w-5xl bg-white rounded-3xl shadow-2xl overflow-hidden">
        {/* Left: Form */}
        <div className="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center">
          <h2 className="text-orange-500 font-extrabold text-4xl font-bold text-center">
            PickMe
          </h2>

          {/* Form */}
          <form className="space-y-6 p-6" onSubmit={handleSubmit}>
            {/* Email */}
            <div>
              <TextField
                fullWidth
                label="Email"
                type="email"
                variant="outlined"
                color="warning"
                name="email"
                value={input.email}
                onChange={handleInputChange}
                error={errors.email}
                helperText={errors.email}
                InputProps={{ className: "rounded-xl" }}
              />
            </div>

            {/* Password */}
            <div>
              <TextField
                fullWidth
                label="Mật khẩu"
                name="password"
                value={input.password}
                onChange={handleInputChange}
                error={errors.password}
                helperText={errors.password}
                type={showPassword ? "text" : "password"}
                variant="outlined"
                color="warning"
                InputProps={{
                  className: "rounded-xl",
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowPassword((show) => !show)}
                        edge="end"
                      >
                        {showPassword ? (
                          <VisibilityIcon />
                        ) : (
                          <VisibilityOffIcon />
                        )}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />
            </div>

            <div>
              <Button
                disabled={loading}
                fullWidth
                variant="contained"
                color="warning"
                size="large"
                sx={{
                  py: 1.5,
                  fontSize: "1rem",
                  borderRadius: "12px",
                  fontWeight: 600,
                  textTransform: "none",
                }}
                type="submit"
              >
                {loading ? (
                  <>
                    <CircularProgress
                      size={16}
                      sx={{ color: "white", mr: 1 }}
                    />
                    <span>Đang đăng nhập...</span>
                  </>
                ) : (
                  "Đăng nhập"
                )}
              </Button>
            </div>
          </form>
        </div>

        {/* Right: Image */}
        <div className="hidden md:block md:w-1/2 bg-orange-100">
          <img src={images.loginImage} className="h-full w-full object-cover" />
        </div>
      </div>
    </div>
  );
}
