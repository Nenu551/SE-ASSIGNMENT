// Task 2: Weekly Study Hours Analyzer

#include <stdio.h>

int main() {
    float hours[7];
    float total = 0, average;
    int highestDay = 0;

    for (int i = 0; i < 7; i++) {

        while (1) {
            printf("Enter study hours for Day %d: ", i + 1);
            scanf("%f", &hours[i]);

            if (hours[i] >= 0 && hours[i] <= 24)
                break;

            printf("Invalid input! Enter hours between 0 and 24.\n");
        }

        total += hours[i];

        if (hours[i] > hours[highestDay])
            highestDay = i;
    }

    average = total / 7;

    printf("\nWeekly Total = %.2f Hours\n", total);
    printf("Daily Average = %.2f Hours\n", average);
    printf("Highest Study Day = Day %d\n\n", highestDay + 1);

    printf("Study Chart\n");

    for (int i = 0; i < 7; i++) {

        printf("Day %d : ", i + 1);

        int stars = (int)hours[i];

        for (int j = 0; j < stars; j++)
            printf("*");

        printf("\n");
    }

    return 0;
}