import requests
import time



service_health="https://system-api-hackthon.onrender.com/health"


while True:
    response = requests.get(url=service_health)
    print(response)
    time.sleep(5)