using System;
using System.Collections.Generic;
using System.Linq;

namespace $rootnamespace$
{
    /// <summary>
    /// Provides a set of methods to extend LINQ to Objects.
    /// </summary>
    public static class Enumerable2
    {
        /// <summary>
        /// Creates an <see cref="IEnumerable{TResult}"/> from a single object.
        /// </summary>
        /// <typeparam name="TResult">The type of the object.</typeparam>
        /// <param name="element">An object.</param>
        /// <returns>An <see cref="IEnumerable{TResult}"/> that contains the input object.</returns>
        [DebuggerHidden]
        public static IEnumerable<TResult> MakeEnumerable<TResult>(this TResult element)
        {
            yield return element;
        }

        /// <summary>
        /// Creates an array from a single object.
        /// </summary>
        /// <typeparam name="TResult">The type of the object.</typeparam>
        /// <param name="element">An object.</param>
        /// <returns>An array that contains the input object.</returns>
        [DebuggerHidden]
        public static TResult[] MakeArray<TResult>(this TResult element)
        {
            return new[] { element };
        }

        /// <summary>
        /// Generates an infinite sequence that contains one repeated value.
        /// </summary>
        /// <typeparam name="TResult">The type of the value to be repeated in the result sequence.</typeparam>
        /// <param name="element">The value to be repeated.</param>
        /// <returns>An <see cref="IEnumerable{TResult}"/> that contains a repeated value.</returns>
        [DebuggerHidden]
        public static IEnumerable<TResult> Repeat<TResult>(TResult element)
        {
            while (true)
                yield return element;
        }

        /// <summary>
        /// Generates a sequence that contains one repeated value.
        /// </summary>
        /// <typeparam name="TResult">The type of the value to be repeated in the result sequence.</typeparam>
        /// <param name="element">The value to be repeated.</param>
        /// <param name="count">The number of times to repeat the value in the generated sequence. <see langword="null"/> if the value is repeated infinitely.</param>
        /// <returns>An <see cref="IEnumerable{TResult}"/> that contains a repeated value.</returns>
        [DebuggerHidden]
        public static IEnumerable<TResult> Repeat<TResult>(TResult element, int? count)
        {
            return count.HasValue ? Enumerable.Repeat(element, count.Value) : Repeat(element);
        }

        /// <summary>
        /// Prepends an element to the head of a sequence.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <param name="source">A sequence of values.</param>
        /// <param name="element">The value to be prepended.</param>
        /// <returns>A concatenated <see cref="IEnumerable{TSource}"/>.</returns>
        [DebuggerHidden]
        public static IEnumerable<TSource> Prepend<TSource>(this IEnumerable<TSource> source, TSource element)
        {
            if (source == null) throw new ArgumentNullException("source");

            yield return element;

            foreach (var item in source)
                yield return item;
        }

        /// <summary>
        /// Appends an element to the tail of a sequence.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <param name="source">A sequence of values.</param>
        /// <param name="element">The value to be appended.</param>
        /// <returns>A concatenated <see cref="IEnumerable{TSource}"/>.</returns>
        [DebuggerHidden]
        public static IEnumerable<TSource> Append<TSource>(this IEnumerable<TSource> source, TSource element)
        {
            if (source == null) throw new ArgumentNullException("source");

            foreach (var item in source)
                yield return item;

            yield return element;
        }

        /// <summary>
        /// Does an action for each element of a sequence.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <param name="source">A sequence of values.</param>
        /// <param name="action">An action to apply to each element.</param>
        /// <returns>An <see cref="IEnumerable{TSource}"/> that contains the same elements as the input sequence.</returns>
        [DebuggerHidden]
        public static IEnumerable<TSource> Do<TSource>(this IEnumerable<TSource> source, Action<TSource> action)
        {
            if (source == null) throw new ArgumentNullException("source");
            if (action == null) throw new ArgumentNullException("action");

            foreach (var item in source)
            {
                action(item);
                yield return item;
            }
        }

        /// <summary>
        /// Executes enumeration of a sequence.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <param name="source">A sequence of values.</param>
        [DebuggerHidden]
        public static void Execute<TSource>(this IEnumerable<TSource> source)
        {
            if (source == null) throw new ArgumentNullException("source");

            foreach (var item in source) ;
        }

        /// <summary>
        /// Executes enumeration of a sequence, and does an action for each element of the sequence.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <param name="source">A sequence of values.</param>
        /// <param name="action">An action to apply to each element.</param>
        [DebuggerHidden]
        public static void Execute<TSource>(this IEnumerable<TSource> source, Action<TSource> action)
        {
            if (source == null) throw new ArgumentNullException("source");
            if (action == null) throw new ArgumentNullException("action");

            foreach (var item in source)
                action(item);
        }

        /// <summary>
        /// Returns distinct elements from a sequence by using the keys to compare values.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <typeparam name="TKey">The type of the key.</typeparam>
        /// <param name="source">A sequence of values.</param>
        /// <param name="keySelector">A function to extract a key from an element.</param>
        /// <returns>An <see cref="IEnumerable{TSource}"/> that contains distinct elements from the input sequence.</returns>
        public static IEnumerable<TSource> Distinct<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
        {
            if (source == null) throw new ArgumentNullException("source");
            if (keySelector == null) throw new ArgumentNullException("keySelector");

            var keySet = new HashSet<TKey>();

            foreach (var item in source)
            {
                var key = keySelector(item);
                if (!keySet.Add(key)) continue;
                yield return item;
            }
        }

        /// <summary>
        /// Segments a sequence by the specified length.
        /// </summary>
        /// <typeparam name="TSource">The type of the elements of source.</typeparam>
        /// <param name="source">A sequence of values.</param>
        /// <param name="lengthOfSegment">The length of a segment.</param>
        /// <returns>A sequence of segments of values.</returns>
        public static IEnumerable<TSource[]> Segment<TSource>(this IEnumerable<TSource> source, int lengthOfSegment)
        {
            if (source == null) throw new ArgumentNullException("source");
            if (lengthOfSegment <= 0) throw new ArgumentOutOfRangeException("lengthOfSegment", lengthOfSegment, "The value must be positive.");

            var l = new List<TSource>();

            foreach (var item in source)
            {
                l.Add(item);

                if (l.Count == lengthOfSegment)
                {
                    yield return l.ToArray();
                    l.Clear();
                }
            }

            if (l.Count > 0)
                yield return l.ToArray();
        }
    }
}
