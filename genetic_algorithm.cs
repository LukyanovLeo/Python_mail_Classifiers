using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//Решаем уравнение F(x) = 3x*sin(x)+x/3
//Производная: 3sin(x) + 3x cos(x) + 1/3 = 0

namespace Genetic
{
    class Genetic
    {        
        private static int PopSize = 50; //array capacity

        public List<double> toInitByRandomValues(int left, int right)   //random 1-st gen. children creation
        {
            Console.WriteLine("Начальная популяция");
            Random rand = new Random();
            List<double> FirstGeneration = new List<double>();
            for (int i = 0; i < PopSize; i++)
            {
                FirstGeneration.Add(rand.NextDouble()*(right-left) + left);
                Console.WriteLine(FirstGeneration[i]);
            }
            return FirstGeneration;
        }

        public List<double> toCreateNewGeneration(List<double> oldPop)
        {
            //вычисляем коэффициенты
            double[] coefs = new double[PopSize];
            Console.WriteLine("Коэффициенты");

            for (int i = 0; i < PopSize; i++)
            {
                coefs[i] = Math.Abs(3 * Math.Sin(oldPop[i]) + 3 * (oldPop[i] * Math.Cos(oldPop[i])) + (1 / 3));
                Console.WriteLine(coefs[i]);
            }

            double summ = 0;

            //calculating summ
            for (int i = 0; i < PopSize; i++)
            {
                summ += 1 / coefs[i];
            }

            //calculating survival coef
            List<double> possibilities = new List<double>();
            Console.WriteLine("Проценты");

            for (int i = 0; i < PopSize; i++)
            {
                possibilities.Add((1 / coefs[i]) / summ);
                Console.WriteLine(possibilities[i] * 100);
            }


            //select suitable parents
            List<double> suitableParents = new List<double>();
            byte counter = 0;
            while (counter < 15)
            {
                double max = possibilities[0];
                for (int i = 1; i < possibilities.Count; i++)
                {
                    if (possibilities[i] > max)
                    {
                        max = possibilities[i];
                    }
                }
                suitableParents.Add(oldPop[possibilities.IndexOf(max)]);
                oldPop.RemoveAt(possibilities.IndexOf(max));
                possibilities.Remove(max);
                counter++;
            }
            
            //creation of new generation
            List<double> NewGeneration = new List<double>();
            //bool[] isFucked = new bool[PopSize];
            counter = 0;
            for (int i = 0; i < suitableParents.Count; i++)
            {
                for (int j = i + 1; j < suitableParents.Count; j++)
                {
                    NewGeneration.Add(whichOne(suitableParents[i], suitableParents[j]));
                }
            }
            counter++;
            Console.WriteLine("Новое поколение");
            for (int i = 0; i < NewGeneration.Count; i++)
            {
                Console.WriteLine(NewGeneration[i]);
            }

            //add mutation
            Random rand = new Random();
            //from 8 to 15 mutations on different values
            int randRange = rand.Next(8, 16);
            int[] mutantPositions = new int[randRange];
            for (int i = 0; i < randRange; i++)
            {
                double mutants = rand.NextDouble() * 6.0 - 3.0;
                mutantPositions[i] = rand.Next(PopSize);
                NewGeneration[mutantPositions[i]] = mutants;
            }

            return NewGeneration;
        }

        public static double whichOne(double d1, double d2)
        {
            Random rnd = new Random();
            double Is = rnd.NextDouble() * 2 - 1;
            if (Is < 0)
                return d1;
            return d2;
        }

        public double solve(double x)
        {
            //F(x) = 3x* sin(x) + x / 3
            return 3 * x * Math.Sin(x) + (x / 3);
        }
    }
    class Program

    {
        static void Main(string[] args)
        {
            Genetic gen = new Genetic();
            char isContinue = 'y';
            while (true)
            {
                Console.Write("Ваша функция: F(x) = 3x*sin(x) + x/3 \nВведите левый интервал: ");
                int left = int.Parse(Console.ReadLine());

                Console.Write("Введите правый интервал: ");
                int right = int.Parse(Console.ReadLine());

                Console.Write("Введите кол-во поколений: ");
                int gens = int.Parse(Console.ReadLine());

                if ((left < right) && (gens > 0))
                {
                    List<double> list = gen.toInitByRandomValues(left, right);

                    for (int i = 0; i < gens; i++)
                    {
                        list = gen.toCreateNewGeneration(list);
                    }
                    Console.Write("Это " + gens + "-е поколение популяции. Значение" +
                        " большей части элементов является приближенным знаечнием одного из экстремумов функции на интервале от " +
                        left + " до " + right + ".\nДля того, чтобы найти значение функции в данном интервале, " +
                        "запишите полученное значение ниже: ");
                    double d = Double.Parse(Console.ReadLine());
                    Console.WriteLine("Значение функции в данной точке: " + gen.solve(d) + "\nНайти ещё экстремумы? (y/n) ");
                    
                    isContinue = char.Parse(Console.ReadLine());
                    if (isContinue == 'y')
                    {
                        continue;
                    }
                    else
                    {
                        break;
                    }
                }
                else
                {
                    Console.WriteLine("Неверный формат");
                }
            }
            Console.ReadKey();
        }
    }
}
