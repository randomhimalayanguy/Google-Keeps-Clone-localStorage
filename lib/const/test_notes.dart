List<String> getTitle() {
  return [
    "Grocery List",
    "Meeting Notes",
    "Travel Ideas",
    "Book Summary",
    "Workout Plan",
  ];
}

List<String> getText() {
  return [
    """# Grocery Shopping

## Fruits
- 🍌 Bananas  
- 🍎 Apples  
- 🍊 Oranges  

## Vegetables
- 🥦 Broccoli  
- 🥕 Carrots  
- 🧄 Garlic  

## Other
- 🥛 Milk  
- 🍞 Bread  
- 🧀 Cheese  

> Tip: Always check the fridge before buying!
""",
    """
# Flutter Basics 📱

## Widgets
- **StatelessWidget** → does not change  
- **StatefulWidget** → can update over time  

## Useful Links
- [Official Flutter Docs](https://flutter.dev/docs)  
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)  

## Example Code
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
      body: Center(child: Text("Hello Flutter!")),
      ),
    ),
  );
}

> Remember: Hot reload is your best friend 🚀

""",
    "Explore Japan in spring for cherry blossoms.\nPossible destinations: Kyoto, Tokyo.\nBudget and itinerary to be planned.\nResearch visa requirements and local festivals.",
    "Atomic Habits by James Clear:\nMain idea: Small changes can lead to remarkable results.\nQuote: \"Habits are the compound interest of self-improvement.\"\nRemember to implement the '2-minute rule.'",
    "Monday: Chest & Triceps\nTuesday: Rest\nWednesday: Back & Biceps\nThursday: Cardio + Abs\nFriday: Legs\nStay hydrated and stretch before each workout.",
  ];
}
