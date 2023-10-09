import serial
import zlib
import json
import requests
import json
from pytz import timezone
from datetime import datetime
from typing import List
from collections import defaultdict

ser = serial.Serial('COM6', 115200)

class TemperatureMessage():
    PACKAGES_TOTAL = 24
    MIN_PACKAGES = 20
    def __init__(self):
        self.packages_received = 0
        self.id_message = None
        self.temperatures = {}

    def append(self,data:dict):
        id_message_received = data['id_message']
        no_pack = data['no_pack']
        if not self.id_message:
            #print("mensaje entrante...")
            self.id_message = id_message_received
            self.temperatures = {}
            self.packages_received = 0
        elif id_message_received>self.id_message and no_pack==1:
            self.id_message = id_message_received
            self.temperatures = {}
            self.packages_received = 0

        print(f"Id de message recibido: {id_message_received}, id de mensaje que solo se acepta: {self.id_message}")
        if id_message_received == self.id_message:
            data_farfi = data['data']
            print(f"numero de paquete: {no_pack}, numero de paquetes ya recibidos: {self.temperatures.keys()}")
            if no_pack not in self.temperatures:
                self.temperatures[no_pack] = data_farfi
                self.packages_received += 1
                #print(f"Imrimiendo array de temperaturas, numero de paquete: {self.packages_received}")
                #print(self.temperatures)

                if self.packages_received > self.MIN_PACKAGES:

                    indices = sorted( list( self.temperatures.keys() ) )
                    array_temperatures = []
                    for index in indices:
                        array_temperatures.extend(
                            self.temperatures[index]
                        )
                    
                    self.create_message(
                        latitude = data["latitude"],
                        longitude = data["longitude"],
                        temperatures= array_temperatures
                    )

                    self.id_message = None
                    self.temperatures = {}
                    self.packages_received = 0


    def create_message(self,latitude:float,longitude:float,temperatures:List[int]):
        print("Mandando registro de temperatura")
        service_create_register_temperature="https://system-api-hackthon.onrender.com/api/v1/dron-temperature/"
        headers = {
            'Content-Type': 'application/json'
        }
        datetime_event = get_current_date_time_zone_utc().isoformat()
        data = {
            "latitude": latitude,
            "longitude": longitude,
            "datetime_event": datetime_event,
            "temperatures": temperatures
        }
        user_data_str_json = json.dumps(data,indent=3)
        #print(user_data_str_json)
        response = requests.post(service_create_register_temperature, json=data, headers=headers)
        #print(response)


def get_current_date_time_zone_utc() -> datetime:
    TIME_ZONE_UTC ="utc" 
    return datetime.now(timezone(TIME_ZONE_UTC))


class Message:
    FIELDS = {
        'total' : 2,
        'no_pack' : 2,
        'latitude': 12,     # 4 enteros, 1 punto, 7 decimales
        'longitude' : 13,   # 5 enteros, 1 punto, 7 decimales
        'data' : 96,        # 32 cifras de 3 digitos cada cifra
        'id_message' : 3,   # 3 numeros
        'check_sum' : 10    # Para un valor sin signo de 4 bytes: 4,294,967,295 es el número más grande.
                            # para un valor con signo de 4 bytes: 2,147,483,647 es el número más grande.
    } 
    
    LENGTH_MESSAGE = sum(list(FIELDS.values()))
    MAX_LENGHT = 152


    def __init__(self) -> None:
        pass

    def convert_to_message(self,message:str):
        response = {}
        success = False

        message_size = len(message)
        if message_size != self.LENGTH_MESSAGE:
            response = f"El mensaje no cumple con la longitud requerida: longitud: {message_size}, longitud esperada: {self.LENGTH_MESSAGE}"
            #print(response)
            return response, success
            
        # Comprobando que CRC32 sea válido...
        message_withouth_crc32 = message[:128]
        crc_32_provided = message[128:]  # 10 dígitos numéricos...

        # Calcula el CRC32 para message_withouth_crc32
        calculated_crc32 = zlib.crc32(message_withouth_crc32.encode()) & 0xFFFFFFFF
        calculated_crc32_str = str(calculated_crc32).zfill(10)  # Asegurarse de que tenga 10 dígitos, llenando con ceros si es necesario

        if calculated_crc32_str != crc_32_provided:
            response = "El CRC32 no coincide."
            #print(response)
            return response, success


        total = int(message[:2])
        no_pack =  int(message[2:4])
        latitude = float(message[4:16])
        longitude = float(message[16:29])
        data = message[29:125]
        data = [int(data[i:i+3]) for i in range(0, len(data), 3)]
        id_message = int(message[125:128])
        success = True
        
        response = {
            "total" : total ,
            "no_pack" : no_pack,
            "latitude" : latitude,
            "longitude" : longitude,
            "data" : data,
            "id_message" : id_message,
            "crc_32" : crc_32_provided
        }
        return response,success
    
    

message = Message()
buffer_data = defaultdict(list)
max_buffer = 3
temperature_message = TemperatureMessage()

while True:
    if ser.in_waiting > 0:
        data = ser.readline()
        data_size = len(data)
        if data_size > 100:
            data = data.decode('ISO-8859-1').strip()
            print("mensaje_llego:",data)
            response,success = message.convert_to_message(
                data
            )
            if success:
                temperature_message.append(
                    data = response
                )

