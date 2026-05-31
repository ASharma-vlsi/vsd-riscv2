# How address offsets are decoded ?

The GPIO peripheral uses memory-mapped address decoding to select different registers. Individual bits of mem_wordaddr are used to identify whether the CPU is accessing the DATA, DIR, or READ register. This allows multiple GPIO registers to be accessed through different memory addresses.

# How direction affects behavior ?

The GPIO direction register (GPIO_DIR) determines whether each GPIO bit acts as an input or output. A bit value of 1 configures the corresponding GPIO pin as an output, while a value of 0 configures it as an input. The output value is generated using:
```
gpio_out = gpio_data & gpio_dir;
```
so only pins configured as outputs can drive external signals.
