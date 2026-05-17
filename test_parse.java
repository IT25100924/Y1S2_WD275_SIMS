import java.util.Arrays;
public class test_parse {
    public static void main(String[] args) {
        String line = "SI008|P004|chocolates|Orange Cooperation|25|1500.0|2026-05-16|Food|2026-10-24|0|";
        String[] parts = line.split("\\|", -1);
        System.out.println("Parts length: " + parts.length);
        for(int i=0; i<parts.length; i++) {
            System.out.println(i + ": " + parts[i]);
        }
        try {
            int q = Integer.parseInt(parts[9]);
            System.out.println("parsed 9: " + q);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
