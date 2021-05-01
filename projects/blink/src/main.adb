with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;
   Pico.LED.Configure (RP.GPIO.Output);
   Pico.GP9.Configure (RP.GPIO.Output);
   RP.Device.Timer.Enable;
   loop
      Pico.LED.Toggle;
      Pico.GP9.Toggle;
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Main;

