//
//  Date + Extensions.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 13.11.2022.
//

import Foundation

extension Date {
    
    func getWeekdayNumber() -> Int { // функция getWeekdayNumber не принимает параметров и возвращает Int
        let calendar = Calendar.current // создаем календарь и помещаем в него текущий календарь
        let weekday = calendar.component(.weekday, from: self) // создаем день недели и помещаем в него компонент дня недели
        return weekday
    }
    
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self)) // константа timeZoneOffset хранит в себе текущий часовой пояс в секундах от текущей даты конвертированный в Double
        let date = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) ?? Date() // константа date содержит в себе текущий календарь с инициализатором добавления смещения по секундам текущего часового пояса
        return date
    }
    
    func getWeekDay() -> [[String]] {
        let formatter = DateFormatter() // константа formatter хранит в себе форматер
        formatter.locale = Locale(identifier: "en_GB") // локаль/язык форматера
        formatter.dateFormat = "EEEEEE" // определяем формат даты Sa/Сб - nsdateformatter.com
        let calendar = Calendar.current // создаем текущий календарь
        
        var weekArray: [[String]] = [[],[]] // создаем двумерный массив
        
        for index in -6...0 { // проходимся по индексам от -6 до 0
            let date = calendar.date(byAdding: .day, value: index, to: self) ?? Date() // константа date содержит в себе календарь с инициализатором добавления смещения по дням
            let day = calendar.component(.day, from: date) // константа day содержит в себе календарь с компонентом дня
            weekArray[1].append("\(day)")
            let weekday = formatter.string(from: date) // константа weekday содержит в себе форматер с неделей
            weekArray[0].append("\(weekday)")
        }
        
        return weekArray
        
    }
    
    func offsetDay(day: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: -day, to: self) ?? Date()
        return date
    }
    
    func offsetMonth(month: Int) -> Date {
        let date = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return date
    }
    
    func dateEndStart() -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let dateStart = formatter.date(from: "\(year)/\(month)/\(day)") ?? Date() // 2022-11-13 21:00:00 UTC
        
        let local = dateStart.localDate() // 2022-11-13 21:00:00 UTC + GMT(3 hours)
        let dateEnd: Date = {
            let components = DateComponents(day: 1)
            return calendar.date(byAdding: components, to: local) ?? Date() // прибавляем к календарю смещение по components(1 день) от локальной даты 2022-11-13 21:00:00 UTC + GMT(3 hours)
        }()
        
        return (local, dateEnd)
    }
    
    func yyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: self)
        return date
    }
    
}
