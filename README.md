# Wall Matters MATLAB 复现简要说明

在 MATLAB 中将当前文件夹切换到本项目目录，执行 `run_all` 生成全部四组图，也可以单独执行下表中的函数。使用 MATLAB R2024a，无需额外工具箱或外部数据文件。

| 论文图号 | MATLAB 函数 | 复现配置 |
| --- | --- | --- |
| 6 | `map_single_wall_ssnr` | 单墙 SSNR 热图。TX 和 RX 分别位于 x = −5 m 和 x = 5 m，墙位于 x = −2.4 m。用 (7.5, 0) m 的 6 dB 边界近似读点标定。 |
| 7 | `sweep_wall_tx_distance` | TX–RX 固定为 10 m，扫描 9.5、9、7、5、3、1、0.5 m 的墙到 TX 距离。七个子图各用一个已有标定系数。 |
| 9 | `sweep_tx_rx_distance` | TX 固定在 x = −5 m，墙固定在 x = 0 m，TX–RX 距离从 6 m 扫到 18 m，步长 2 m。各组用原图在 y = 0 的最左边界交点标定。 |
| 10 | `compare_wall_counts` | TX 和 RX 分别位于 x = −5 m 和 x = 7 m。单墙位于 x = 0 m，双墙位于 x = 0、4 m。单墙用一个近似读点标定，双墙用六个近似读点拟合，并在命令窗口报告拟合误差。 |

坐标和距离单位均为米，感知边界阈值为 6 dB。边界读点和拟合用于近似重画论文图形。各实验的参数位于对应函数内。每次运行会在 `results/<函数名>/` 下保存 PNG 和 MATLAB FIG，同名文件会被覆盖。
