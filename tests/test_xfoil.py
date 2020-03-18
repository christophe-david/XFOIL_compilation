import os
import os.path as pth
import platform
import subprocess
import numpy as np
from numpy.testing import assert_allclose

POLAR_RESULT = "polar_result.txt"


def test_xfoil_full_iterations():
    """
    Tests a XFOIL polar with 200 iterations per point

    All points that can converge are expected to be there
    """
    if pth.exists(POLAR_RESULT):
        os.remove(POLAR_RESULT)

    # Get built xfoil path
    xfoil_path = pth.join(pth.dirname(__file__), pth.pardir, "bin", "xfoil")

    with open(
        pth.join(pth.dirname(__file__), "test_session_200it.txt")
    ) as session_inputs:
        if platform.system() == "Windows":
            # Reference test using official build
            subprocess.run(["xfoil.exe"], stdin=session_inputs)
        elif platform.system() == "Darwin":
            # Test macOS build
            subprocess.run([xfoil_path], stdin=session_inputs)

    result = np.genfromtxt(POLAR_RESULT, skip_header=12)
    alpha = result[:, 0]
    CL = result[:, 1]

    reference = np.genfromtxt(
        pth.join(pth.dirname(__file__), "polar_result_ref.txt"), skip_header=12
    )
    alpha_ref = reference[:, 0]
    CL_ref = reference[:, 1]

    assert_allclose(
        alpha, alpha_ref, atol=1e-4,
    )
    assert_allclose(
        CL, CL_ref, atol=1e-4,
    )

    assert len(CL) > 50
    assert np.max(alpha) > 25.0


def test_xfoil_reduced_iterations():
    """
    Tests a XFOIL polar with 20 iterations per point

    Some points are expected to not converge and be missing in the result polar.
    It is checked that:
    - results of computed point have same CL value as with large iteration count.
    - enough points are computed
    - max CL is obtained
    """

    if pth.exists(POLAR_RESULT):
        os.remove(POLAR_RESULT)

    # Get built xfoil path
    xfoil_path = pth.join(pth.dirname(__file__), pth.pardir, "bin", "xfoil")

    with open(
        pth.join(pth.dirname(__file__), "test_session_20it.txt")
    ) as session_inputs:
        if platform.system() == "Windows":
            # Reference test using official build
            subprocess.run(["xfoil.exe"], stdin=session_inputs)
        elif platform.system() == "Darwin":
            # Test macOS build
            subprocess.run([xfoil_path], stdin=session_inputs)

    result = np.genfromtxt(POLAR_RESULT, skip_header=12)
    alpha = result[:, 0]
    CL = result[:, 1]

    reference = np.genfromtxt(
        pth.join(pth.dirname(__file__), "polar_result_ref.txt"), skip_header=12
    )
    alpha_ref = reference[:, 0]
    CL_ref = reference[:, 1]

    idx_ref = np.isin(alpha_ref, alpha)
    assert_allclose(
        CL, CL_ref[idx_ref], atol=1e-4,
    )

    assert len(CL) > 50
    assert np.max(alpha) > 25.0
    assert_allclose(
        np.max(CL), np.max(CL_ref), atol=1e-4,
    )
