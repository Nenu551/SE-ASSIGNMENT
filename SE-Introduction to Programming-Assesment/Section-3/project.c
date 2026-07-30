#include <stdio.h>

#define SUBJECTS 3
#define DAYS 7

struct StudyLog {
    char subject[40];
    float hours[7];
};

void logStudyHours(struct StudyLog s[]) {
    int day;

    printf("\nEnter Day Number (1-7): ");
    scanf("%d", &day);

    if (day < 1 || day > 7) {
        printf("Invalid day!\n");
        return;
    }

    printf("\nEnter study hours for Day %d\n", day);

    for (int i = 0; i < SUBJECTS; i++) {
        printf("%s: ", s[i].subject);
        scanf("%f", &s[i].hours[day - 1]);
    }

    printf("\nStudy hours logged successfully.\n");
}

void viewWeeklyReport(struct StudyLog s[]) {

    printf("\n========== WEEKLY REPORT ==========\n");

    for (int i = 0; i < SUBJECTS; i++) {

        float total = 0;

        printf("\nSubject : %s\n", s[i].subject);

        for (int j = 0; j < DAYS; j++)
            total += s[i].hours[j];

        float average = total / DAYS;

        printf("Weekly Total : %.2f Hours\n", total);
        printf("Daily Average : %.2f Hours\n", average);

        printf("Progress Chart\n");

        for (int j = 0; j < DAYS; j++) {

            printf("Day %d : ", j + 1);

            int dots = (int)s[i].hours[j];

            for (int k = 0; k < dots; k++)
                printf("•");

            printf("\n");
        }
    }
}

void saveToFile(struct StudyLog s[]) {

    FILE *fp;

    fp = fopen("productivity_log.txt", "w");

    if (fp == NULL) {
        printf("File cannot be opened.\n");
        return;
    }

    for (int i = 0; i < SUBJECTS; i++) {

        fprintf(fp, "%s", s[i].subject);

        for (int j = 0; j < DAYS; j++) {
            fprintf(fp, ",%.2f", s[i].hours[j]);
        }

        fprintf(fp, "\n");
    }

    fclose(fp);

    printf("\nData saved successfully in productivity_log.txt\n");
}

int main() {

    struct StudyLog subjects[SUBJECTS] = {
        {"C Programming", {0}},
        {"HTML & CSS", {0}},
        {"Data Structures", {0}}
    };

    int choice;

    do {

        printf("\n========== STUDENT PRODUCTIVITY TRACKER ==========\n");
        printf("1. Log Today's Study Hours\n");
        printf("2. View Weekly Report\n");
        printf("3. Save & Exit\n");

        printf("Enter Choice: ");
        scanf("%d", &choice);

        switch (choice) {

            case 1:
                logStudyHours(subjects);
                break;

            case 2:
                viewWeeklyReport(subjects);
                break;

            case 3:
                saveToFile(subjects);
                printf("Thank You!\n");
                break;

            default:
                printf("Invalid Choice!\n");
        }

    } while (choice != 3);

    return 0;
}