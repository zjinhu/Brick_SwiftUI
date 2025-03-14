//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension Binding where Value == String {
    ///TextField TextEditor 限制输入字符
    public func textLimit(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

extension Binding {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(_from binding: FocusState<Value>.Binding) where Value: Hashable {
        self.init(get: { binding.wrappedValue },
                  set: { binding.wrappedValue = $0 })
    }
}

extension Binding {
    public func cast<T, U>() -> Binding<Optional<U>> where Value == Optional<T> {
        Binding<Optional<U>>(
            get: {
                self.wrappedValue.flatMap({ $0 as? U })
            },
            set: { newValue in
                self.wrappedValue = newValue as? T
            }
        )
    }

    public func _cast<T>(
        to type: T.Type = T.self
    ) -> Binding<Optional<T>> {
        Binding<Optional<T>>(
            get: {
                self.wrappedValue as? T
            },
            set: { newValue in
                guard let _newValue = newValue as? Value else {
                    assertionFailure()
                    
                    return
                }
                
                self.wrappedValue = _newValue
            }
        )
    }

    public func _cast<T>(
        to type: T.Type = T.self,
        defaultValue: @escaping () -> T
    ) -> Binding<T> {
        Binding<T>(
            get: {
                (self.wrappedValue as? T) ?? defaultValue()
            },
            set: { newValue in
                guard let _newValue = newValue as? Value else {
                    assertionFailure()
                    
                    return
                }
                 
                self.wrappedValue = _newValue
            }
        )
    }

    /// Creates a `Binding` by force-casting this binding's value.
    public func forceCast<T>(to type: T.Type = T.self) -> Binding<T> {
        Binding<T>(
            get: {
                self.wrappedValue as! T
            },
            set: { newValue in
                self.wrappedValue = newValue as! Value
            }
        )
    }
}

extension Binding {
    public func map<T>(_ keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        .init(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
    
    public func _map<T>(_ transform: @escaping (Value) -> T,
                        _ reverse : @escaping (T) -> Value) -> Binding<T> {
        Binding<T>(
            get: { transform(self.wrappedValue) },
            set: { wrappedValue = reverse($0) }
        )
    }
    
    public func _map<T, U>(_ transform: @escaping (T) -> U,
                           _ reverse : @escaping (U) -> T) -> Binding<U?> where Value == Optional<T> {
        Binding<U?>(
            get: { self.wrappedValue.map(transform) },
            set: { wrappedValue = $0.map(reverse) }
        )
    }
}

extension Binding {
    
    public func onSet(perform body: @escaping (Value) -> ()) -> Self {
        return .init(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0; body($0) }
        )
    }
    
    public func onChange(perform action: @escaping (Value) -> ()) -> Self where Value: Equatable {
        return .init(
            get: { self.wrappedValue },
            set: { newValue in
                let oldValue = self.wrappedValue
                
                self.wrappedValue = newValue
                
                if newValue != oldValue  {
                    action(newValue)
                }
            }
        )
    }
    
    public func onChange(toggle value: Binding<Bool>) -> Self where Value: Equatable {
        onChange { _ in
            value.wrappedValue.toggle()
        }
    }

    public func mirror(
        to other: Binding<Value>
    ) -> Binding<Value> {
        onSet(perform: { other.wrappedValue = $0 })
    }
    
    public func printOnSet() -> Self {
        onSet {
            print("Set value: \($0)")
        }
    }
}

extension Binding {
    public func _asOptional(defaultValue: Value) -> Binding<Optional<Value>> {
        .init(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 ?? defaultValue }
        )
    }
    
    public func withDefaultValue<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T> {
        .init(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    public func forceUnwrap<T>() -> Binding<T> where Value == Optional<T> {
        .init(
            get: { self.wrappedValue! },
            set: { self.wrappedValue = $0 }
        )
    }
    
    public func isNil<Wrapped>() -> Binding<Bool> where Optional<Wrapped> == Value {
        .init(
            get: { self.wrappedValue == nil },
            set: { isNil in self.wrappedValue = isNil ? nil : self.wrappedValue  }
        )
    }
    
    public func isNotNil<Wrapped>() -> Binding<Bool> where Optional<Wrapped> == Value {
        .init(
            get: { self.wrappedValue != nil },
            set: { isNotNil in self.wrappedValue = isNotNil ? self.wrappedValue : nil  }
        )
    }
    
    public func nilIfEmpty<T: Collection>() -> Binding where Value == Optional<T> {
        Binding(
            get: {
                guard let wrappedValue = self.wrappedValue, !wrappedValue.isEmpty else {
                    return nil
                }
                
                return wrappedValue
            },
            set: { newValue in
                if let newValue = newValue {
                    self.wrappedValue = newValue.isEmpty ? nil : newValue
                } else {
                    self.wrappedValue = nil
                }
            }
        )
    }
    
    public static func unwrapping(_ other: Binding<Value?>) -> Self? {
          guard let wrappedValue = other.wrappedValue else {
              return nil
          }
          
          return Binding(
              get: { other.wrappedValue ?? wrappedValue },
              set: { other.wrappedValue = $0 }
          )
      }
}

extension Binding {
    public static func && (lhs: Binding, rhs: Bool) -> Binding where Value == Bool {
        .init(
            get: { lhs.wrappedValue && rhs },
            set: { lhs.wrappedValue = $0 }
        )
    }
    
    public static func && (lhs: Binding, rhs: Bool) -> Binding where Value == Bool? {
        .init(
            get: { lhs.wrappedValue.map({ $0 && rhs }) },
            set: { lhs.wrappedValue = $0 }
        )
    }
    
    /// Creates a `Binding<Bool>` that reports whether `binding.wrappedValue` equals a given value.
       ///
       /// `binding.wrappedValue` will be set to `nil` only if `binding.wrappedValue` is equal to the given value and the `Boolean` value being set is `false.`
       public static func boolean<T: Equatable>(
           _ binding: Binding<T?>,
           equals value: T?
       ) -> Binding<Bool> where Value == Bool {
           .init(
               get: {
                   binding.wrappedValue == value
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue = value
                   } else {
                       if binding.wrappedValue == value {
                           binding.wrappedValue = nil
                       }
                   }
               }
           )
       }
       
       /// Creates a `Binding<Bool>` that reports whether `binding.wrappedValue` equals a given value.
       ///
       /// `binding.wrappedValue` will be set to `nil` only if `binding.wrappedValue` is equal to the given value and the `Boolean` value being set is `false.`
       public static func boolean<T: Equatable>(
           _ binding: Binding<T?>,
           equals value: T
       ) -> Binding<Bool> where Value == Bool {
           .init(
               get: {
                   binding.wrappedValue == value
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue = value
                   } else {
                       if binding.wrappedValue == value {
                           binding.wrappedValue = nil
                       }
                   }
               }
           )
       }
       
       /// Creates a `Binding<Bool>` that reports whether `binding.wrappedValue` equals a given value.
       ///
       /// `binding.wrappedValue` will be set to `nil` only if `binding.wrappedValue` is equal to the given value and the `Boolean` value being set is `false.`
       public static func boolean<T: AnyObject>(
           _ binding: Binding<T?>,
           equals value: T
       ) -> Binding<Bool> where Value == Bool {
           .init(
               get: {
                   binding.wrappedValue === value
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue = value
                   } else {
                       if binding.wrappedValue === value {
                           binding.wrappedValue = nil
                       }
                   }
               }
           )
       }
       
       /// Creates a `Binding<Bool>` that reports whether `binding.wrappedValue` equals a given value.
       ///
       /// `binding.wrappedValue` will be set to `nil` only if `binding.wrappedValue` is equal to the given value and the `Boolean` value being set is `false.`
       public static func boolean<T: AnyObject & Equatable>(
           _ binding: Binding<T?>,
           equals value: T
       ) -> Binding<Bool> where Value == Bool {
           .init(
               get: {
                   binding.wrappedValue == value
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue = value
                   } else {
                       if binding.wrappedValue == value {
                           binding.wrappedValue = nil
                       }
                   }
               }
           )
       }

       /// Creates a `Binding<Bool>` that reports whether `binding.wrappedValue` equals a given value.
       ///
       /// `binding.wrappedValue` will be set to `nil` only if `binding.wrappedValue` is equal to the given value and the `Boolean` value being set is `false.`
       public static func boolean<T: Equatable>(
           _ binding: Binding<T>,
           equals value: T,
           default defaultValue: T
       ) -> Binding<Bool> where Value == Bool {
           .init(
               get: {
                   binding.wrappedValue == value
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue = value
                   } else {
                       if binding.wrappedValue == value {
                           binding.wrappedValue = defaultValue
                       }
                   }
               }
           )
       }
       
       public static func boolean<T: Hashable>(
           _ binding: Binding<Set<T>>,
           contains value: T
       ) -> Binding<Bool> {
           Binding<Bool>(
               get: {
                   binding.wrappedValue.contains(value)
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue.insert(value)
                   } else {
                       binding.wrappedValue.remove(value)
                   }
               }
           )
       }
       
       public static func boolean<T: Hashable>(
           _ binding: Binding<Set<T>>,
           equals value: T
       ) -> Binding<Bool> {
           Binding<Bool>(
               get: {
                   binding.wrappedValue == [value]
               },
               set: { newValue in
                   if newValue {
                       binding.wrappedValue = [value]
                   } else {
                       binding.wrappedValue.remove(value)
                   }
               }
           )
       }
}

extension Binding {
    public func removeDuplicates() -> Self where Value: Equatable {
        return .init(
            get: { self.wrappedValue },
            set: { newValue in
                let oldValue = self.wrappedValue
                
                guard newValue != oldValue else {
                    return
                }
                
                self.wrappedValue = newValue
            }
        )
    }
}

extension Binding {
    public func takePrefix(_ count: Int) -> Self where Value == String {
        .init(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                self.wrappedValue = .init($0.prefix(count))
            }
        )
    }
    
    public func takeSuffix(_ count: Int) -> Self where Value == String {
        .init(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                self.wrappedValue = .init($0.suffix(count))
            }
        )
    }
    
    public func takePrefix(_ count: Int) -> Self where Value == String? {
        .init(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                self.wrappedValue = $0.map({ .init($0.prefix(count)) })
            }
        )
    }
    
    public func takeSuffix(_ count: Int) -> Self where Value == String? {
        .init(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                self.wrappedValue = $0.map({ .init($0.suffix(count)) })
            }
        )
    }
}
