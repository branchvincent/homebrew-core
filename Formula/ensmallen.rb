class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.16.0.tar.gz"
  sha256 "3fb2181a5335daf8ba4e8aaecf345dfcc69fdd13d29b05b7c98b8403612a1109"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "898ed64373a7bca9f23396704ca2823521fdbbd92842607803ef445ea9ab9a5d"
    sha256 cellar: :any_skip_relocation, catalina: "8a2e13ad95a4ecb25beab404dcd9ac25bfcba1d9d0ed1abfae07657ab4f284f3"
    sha256 cellar: :any_skip_relocation, mojave:   "67ca6c31a9b776d73dbc6326794d394b60d4f9d558fe5361f9793f04f2212859"
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                    "-o", "test"
  end
end
