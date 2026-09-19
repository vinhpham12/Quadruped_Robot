#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

int main(void)
{
    printk("Quadruped F723 Controller Board initialized successfully!\n");

    while (1) {
        printk("System heartbeat...\n");
        k_msleep(1000);
    }

    return 0;
}
