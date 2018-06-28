#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
	DDRB = 0xFF;
	DDRC = 0xFF;

	while (1) {
		PORTB = 0xFF;
		PORTC = 0xFF;
		_delay_ms(1000);
		PORTB = 0x00;
		PORTC = 0x00;
		_delay_ms(1000);
	}
}
