import re

def extract_order_numbers(text):
    # Паттерн для поиска номеров заказов после слова "Заказ"
    pattern = r'Заказ\s+(\d+)'
    # Находим все совпадения
    matches = re.findall(pattern, text)
    return matches

def process_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
            order_numbers = extract_order_numbers(text)
            return order_numbers
    except FileNotFoundError:
        print(f"Ошибка: Файл {file_path} не найден")
        return []
    except Exception as e:
        print(f"Произошла ошибка при чтении файла: {e}")
        return []

# Пример использования
if __name__ == "__main__":
    file_path = input("Введите путь к файлу: ")
    order_numbers = process_file(file_path)
    if order_numbers:
        print("Найденные номера заказов:", order_numbers)
    else:
        print("Номера заказов не найдены") 