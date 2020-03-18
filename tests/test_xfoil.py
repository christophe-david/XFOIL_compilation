import os
import os.path as pth
import platform
import subprocess
import numpy as np
from numpy.testing import assert_allclose

POLAR_RESULT = "polar_result.txt"


def test_xfoil():

    if pth.exists(POLAR_RESULT):
        os.remove(POLAR_RESULT)

    # Get built xfoil path
    xfoil_path = pth.join(pth.dirname(__file__), pth.pardir, "bin", "xfoil")

    with open("test_session.txt") as session_inputs:
        with open("session.log", "w") as session_log:
            if platform.system() == "Windows":
                # Reference test using official build
                subprocess.run(["xfoil.exe"], stdin=session_inputs, stdout=session_log)
            elif platform.system() == "Darwin":
                # Test macOS build
                subprocess.run([xfoil_path], stdin=session_inputs, stdout=session_log)

    result = np.genfromtxt(POLAR_RESULT, skip_header=12)
    CL = result[:, 1]

    assert_allclose(
        CL,
        [
            0.4917,
            0.5497,
            0.6068,
            0.7209,
            0.7789,
            0.8368,
            0.8945,
            0.9512,
            1.0072,
            1.0612,
            1.1118,
            1.1575,
            1.2025,
            1.2493,
            1.2978,
            1.3461,
            1.3928,
            1.4366,
            1.4788,
            1.5113,
            1.5438,
            1.5671,
            1.5949,
            1.6176,
            1.6352,
            1.6366,
            1.6472,
            1.6509,
            1.6488,
            1.6444,
            1.6362,
            1.6207,
            1.5977,
            1.5676,
            1.5319,
            1.4932,
            1.4600,
            1.4314,
            1.4039,
            1.3770,
            1.3510,
            1.3269,
            1.3023,
            1.2706,
            1.2554,
            0.8248,
            0.8297,
            0.8314,
            0.8340,
            0.8364,
            0.8401,
            0.8438,
            0.8459,
            0.8482,
            0.8506,
            0.8532,
        ],
        atol=1e-4,
    )
