using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace TbkQRParser
{
    /// <summary>
    /// Перечисление товарных групп табачной продукции согласно классификации Честный ЗНАК.
    /// </summary>
    public enum ProductGroup
    {
        /// <summary>
        /// Сигареты с фильтром
        /// </summary>
        [Display(Name = "Сигареты с фильтром")]
        CigarettesWithFilter = 100,

        /// <summary>
        /// Сигареты без фильтра
        /// </summary>
        [Display(Name = "Сигареты без фильтра")]
        CigarettesWithoutFilter = 200,

        /// <summary>
        /// Сигариллы
        /// </summary>
        [Display(Name = "Сигариллы")]
        Cigarillos = 300,

        /// <summary>
        /// Сигары
        /// </summary>
        [Display(Name = "Сигары")]
        Cigars = 400,

        /// <summary>
        /// Табак курительный
        /// </summary>
        [Display(Name = "Табак курительный")]
        SmokingTobacco = 500,

        /// <summary>
        /// Табак трубочный
        /// </summary>
        [Display(Name = "Табак трубочный")]
        PipeTobacco = 600,

        /// <summary>
        /// Табак насвайный
        /// </summary>
        [Display(Name = "Табак насвайный")]
        NaswayTobacco = 700,

        /// <summary>
        /// Электронные системы доставки никотина
        /// </summary>
        [Display(Name = "Электронные системы доставки никотина")]
        ElectronicNicotineDeliverySystems = 800,

        /// <summary>
        /// Жидкости для электронных систем доставки никотина
        /// </summary>
        [Display(Name = "Жидкости для электронных систем доставки никотина")]
        LiquidsForElectronicNicotineDeliverySystems = 900,

        /// <summary>
        /// Табачная продукция прочая
        /// </summary>
        [Display(Name = "Табачная продукция прочая")]
        OtherTobaccoProducts = 999
    }

    /// <summary>
    /// Класс-расширение для работы с enum ProductGroup
    /// </summary>
    public static class ProductGroupExtensions
    {
        /// <summary>
        /// Получает отображаемое имя для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <returns>Отображаемое имя</returns>
        public static string GetDisplayName(this ProductGroup productGroup)
        {
            var fieldInfo = productGroup.GetType().GetField(productGroup.ToString());
            var attributes = (DisplayAttribute[])fieldInfo.GetCustomAttributes(typeof(DisplayAttribute), false);
            return attributes.Length > 0 ? attributes[0].Name : productGroup.ToString();
        }

        /// <summary>
        /// Получает все товарные группы с их отображаемыми именами
        /// </summary>
        /// <returns>Словарь товарных групп</returns>
        public static Dictionary<ProductGroup, string> GetAllProductGroups()
        {
            return Enum.GetValues(typeof(ProductGroup))
                .Cast<ProductGroup>()
                .ToDictionary(pg => pg, pg => pg.GetDisplayName());
        }
    }
}