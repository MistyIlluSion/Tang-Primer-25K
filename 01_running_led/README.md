## Hardware

With core board, dock board, and a PMOD-LEDx8:

![Hardware for Running LED](../images/running_LED_hardware.jpg)


## Create Project

Open Gowin FPGA Designer, click New Project to build a FPGA Design Project, choose project name and directory.

![Create FPGA project](../images/create_fpga_project.png)

Select device `GW5A-LV25MG121NC1/I0`. (If using Gowin Education, perhaps `GW5A-LV25MG121NES`)

![Select Device](../images/select_device.png)


## Create Verilog File

In the left design window, right click to create new verilog file.

![Create new file](../images/create_new_file.png)

![Create new verilog file](../images/create_new_verilog_file.png)

Set a proper file name, and check `Add to current project`.

![Set new verilog file](../images/set_new_verilog_file.png)


## RTL code

In verilog file, input:

```verilog
module RunningLED
(
    input clk,          // 50M Hz clock
    input rst,          // Reset from button
    output [7:0] oLED   // Output for 8-bit LEDs
);

localparam COUNTER_MAX = 32'd9_999_999;

reg [32:0] counter = 32'b0;
reg [7:0] rLED = 8'b1111_1110;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        rLED <= 8'b1111_1110;
        counter <= counter + 1'b1;
    end else begin
        if ( counter <= COUNTER_MAX ) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 32'b0;
            rLED <= {rLED[6:0], rLED[7]};
        end
    end
end

assign oLED = rLED;

endmodule
```


## Synthesize

Select `process` window.

![Select process window](../images/select_process_window.png)

Double click `Synthesize` or right-click it to run.

![Synthesize](../images/synthesize.png)


## Add Physical Constraints

Double click `FloorPlanner` to create a `.cst` file.

![Floorplanner](../images/floorplanner.png)

![Create .cst file](../images/create_cst_file.png)

In the FloorPlanner window, select `IO Constraints`.

![Select IO constraints](../images/select_IO_constraints.png)

In this case, we set pins for IO as below, and the pull mode of `rst` is `DOWN` because `rst` is active high.

![IO constraints for running LED](../images/IO_constraints_running_LED.png)

Then `ctrl+s` to save it, and just close the window.


## Add Timing Constraints

Double click `Timing Constraints Editor` to create a `.sdc` file

![Timing Constraints Editor](../images/timing_constraints_editor.png)

![Create .sdc file](../images/create_sdc_file.png)

Create a clock.

![Create clock](../images/create_clock.png)

Set its name and frequency.

![Set clock](../images/set_clock.png)

Click the `...` box right to `Objects`.

![Set objects](../images/select_objects_clk.png)

Click OK and `ctrl+s` to save, then close the window.

Now we have `.v`, `.cst` and `.sdc` files.

![.v .cst .sdc file](../images/v_cst_sdc_file.png)


## Place & Route

Right-click `Place & Route` and open configuration. In `Dual-Purpose Pin`, check `Use CPU as regular IO`.

![Place and route configuration](../images/place_and_route_configuration.png)

Then click OK. Double click `Place & Route` to run.

![Place & route](../images/place_and_route.png)

If no error occurs, it is ready to program the FPGA.


## Program

Double click `Programmer`.

![Programmer](../images/programmer.png)

Wait it to scan the device, then program it.

![Program the device](../images/program_device.png)

Then you will see the running LED!

![Running LED](../images/running_led.gif)

You can press the button `S2` (with pin `H10`) to reset it.
 