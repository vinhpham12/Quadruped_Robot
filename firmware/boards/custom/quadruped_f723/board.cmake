# SPDX-License-Identifier: Apache-2.0

board_runner_args(openocd "--target=stm32f7x")
include(${ZEPHYR_BASE}/boards/common/openocd.board.cmake)
