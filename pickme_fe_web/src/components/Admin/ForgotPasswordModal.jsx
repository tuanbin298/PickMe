import { useState } from "react";
import { Button, CircularProgress, TextField } from "@mui/material";
import { toast } from "react-toastify";
import authService from "../../../services/auth/authService";

export default function ForgotPasswordModal({ isOpen, onClose }) {
  // State
  const [step, setStep] = useState(1);
  const [email, setEmail] = useState("");
  const [otp, setOtp] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);

  if (!isOpen) return null;

  const token = localStorage.getItem("sessionToken") || "";

  // Send OTP
  const handleSendOtp = async () => {
    if (!email) {
      toast.error("Vui lòng nhập email!");
      return;
    }

    setLoading(true);

    try {
      await authService.sendOtp(email, token);
      toast.success("OTP đã được gửi đến email của bạn!");
      setStep(2);
    } catch (error) {
      toast.error(error.message || "Gửi OTP thất bại!");
    } finally {
      setLoading(false);
    }
  };

  // Verify OTP
  const handleVerifyOtp = async () => {
    if (!otp) {
      toast.error("Vui lòng nhập OTP!");
      return;
    }

    setLoading(true);

    try {
      await authService.verifyOtp(email, otp, token);
      toast.success("Xác thực OTP thành công!");
      setStep(3);
    } catch (error) {
      toast.error(error.message || "OTP không hợp lệ!");
    } finally {
      setLoading(false);
    }
  };

  // Submit new password
  const handleResetPassword = async () => {
    if (!newPassword || newPassword.length < 6) {
      toast.error("Mật khẩu mới phải ít nhất 6 ký tự!");
      return;
    }
    if (/\s/.test(newPassword)) {
      toast.error("Mật khẩu không được chứa khoảng trắng!");
      return;
    }
    if (newPassword !== confirmPassword) {
      toast.error("Mật khẩu xác nhận không khớp!");
      return;
    }

    setLoading(true);

    try {
      await authService.resetPassword(email, otp, newPassword, token);
      toast.success("Đặt lại mật khẩu thành công!");
      setStep(1);
      setEmail("");
      setOtp("");
      setNewPassword("");
      setConfirmPassword("");
      onClose();
    } catch (error) {
      toast.error(error.message || "Đặt lại mật khẩu thất bại!");
    } finally {
      setLoading(false);
    }
  };

  // Every step in process to reset password
  const renderStepContent = () => {
    switch (step) {
      // Submit email
      case 1:
        return (
          <>
            <TextField
              fullWidth
              label="Email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              variant="outlined"
              color="warning"
              InputProps={{ className: "rounded-xl" }}
              required
            />

            <Button
              fullWidth
              variant="contained"
              color="warning"
              disabled={loading}
              onClick={handleSendOtp}
              sx={{
                py: 1.5,
                fontWeight: 600,
                textTransform: "none",
                borderRadius: "12px",
              }}
            >
              {loading ? (
                <CircularProgress size={16} sx={{ color: "white" }} />
              ) : (
                "Gửi OTP"
              )}
            </Button>
          </>
        );
      // Submit OTP
      case 2:
        return (
          <>
            <TextField
              fullWidth
              label="OTP"
              value={otp}
              onChange={(e) => setOtp(e.target.value)}
              variant="outlined"
              color="warning"
              InputProps={{ className: "rounded-xl" }}
              required
            />

            <Button
              fullWidth
              variant="contained"
              color="warning"
              disabled={loading}
              onClick={handleVerifyOtp}
              sx={{
                py: 1.5,
                fontWeight: 600,
                textTransform: "none",
                borderRadius: "12px",
              }}
            >
              {loading ? (
                <CircularProgress size={16} sx={{ color: "white" }} />
              ) : (
                "Xác thực OTP"
              )}
            </Button>
          </>
        );
      // Submit new password
      case 3:
        return (
          <>
            <TextField
              fullWidth
              label="Mật khẩu mới"
              type="password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              variant="outlined"
              color="warning"
              InputProps={{ className: "rounded-xl" }}
              required
            />

            <TextField
              fullWidth
              label="Xác nhận mật khẩu"
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              variant="outlined"
              color="warning"
              InputProps={{ className: "rounded-xl" }}
              required
            />

            <Button
              fullWidth
              variant="contained"
              color="warning"
              disabled={loading}
              onClick={handleResetPassword}
              sx={{
                py: 1.5,
                fontWeight: 600,
                textTransform: "none",
                borderRadius: "12px",
              }}
            >
              {loading ? (
                <CircularProgress size={16} sx={{ color: "white" }} />
              ) : (
                "Đặt lại mật khẩu"
              )}
            </Button>
          </>
        );
      default:
        return null;
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-md p-8 flex flex-col relative">
        <button
          className="absolute top-4 right-4 text-gray-500 hover:text-gray-800 text-lg"
          onClick={() => {
            setStep(1);
            onClose();
          }}
        >
          ✕
        </button>

        <h2 className="text-2xl font-bold text-center text-orange-500 mb-3">
          Quên mật khẩu?
        </h2>

        <p className="text-gray-600 text-center mb-6 text-sm">
          {step === 1 && "Nhập email để nhận OTP."}
          {step === 2 && "Nhập mã OTP đã gửi đến email của bạn."}
          {step === 3 && "Nhập mật khẩu mới và xác nhận."}
        </p>

        <form className="flex flex-col gap-4">{renderStepContent()}</form>

        <Button
          type="button"
          fullWidth
          variant="text"
          onClick={() => {
            setStep(1);
            onClose();
          }}
          sx={{ textTransform: "none", color: "#f97316", mt: 3 }}
        >
          Hủy
        </Button>
      </div>
    </div>
  );
}
