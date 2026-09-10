using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Chocodelight_Website.DataAccess
{
    /// <summary>
    /// Thin ADO.NET helper. All database access goes through stored procedures;
    /// no inline SQL anywhere in the application.
    /// </summary>
    public static class Db
    {
        public static string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["Chocodelight"].ConnectionString; }
        }

        public static SqlConnection OpenConnection()
        {
            var cn = new SqlConnection(ConnectionString);
            cn.Open();
            return cn;
        }

        private static SqlCommand BuildCommand(SqlConnection cn, string procName, params SqlParameter[] parameters)
        {
            var cmd = new SqlCommand(procName, cn) { CommandType = CommandType.StoredProcedure };
            if (parameters != null)
            {
                foreach (var p in parameters)
                {
                    if (p == null) continue;
                    if (p.Value == null) p.Value = DBNull.Value;
                    cmd.Parameters.Add(p);
                }
            }
            return cmd;
        }

        public static SqlParameter P(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }

        public static SqlParameter PStructured(string name, string typeName, DataTable table)
        {
            return new SqlParameter(name, SqlDbType.Structured) { TypeName = typeName, Value = table };
        }

        /// <summary>Executes a stored procedure and returns the first result set as a DataTable.</summary>
        public static DataTable GetTable(string procName, params SqlParameter[] parameters)
        {
            using (var cn = OpenConnection())
            using (var cmd = BuildCommand(cn, procName, parameters))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        /// <summary>Executes a stored procedure and returns every result set.</summary>
        public static DataSet GetDataSet(string procName, params SqlParameter[] parameters)
        {
            using (var cn = OpenConnection())
            using (var cmd = BuildCommand(cn, procName, parameters))
            using (var da = new SqlDataAdapter(cmd))
            {
                var ds = new DataSet();
                da.Fill(ds);
                return ds;
            }
        }

        public static object GetScalar(string procName, params SqlParameter[] parameters)
        {
            using (var cn = OpenConnection())
            using (var cmd = BuildCommand(cn, procName, parameters))
            {
                return cmd.ExecuteScalar();
            }
        }

        public static int Execute(string procName, params SqlParameter[] parameters)
        {
            using (var cn = OpenConnection())
            using (var cmd = BuildCommand(cn, procName, parameters))
            {
                return cmd.ExecuteNonQuery();
            }
        }
    }

    /// <summary>Convenience extensions for reading nullable DataRow columns.</summary>
    public static class DataRowExtensions
    {
        public static string Str(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value ? row[col].ToString() : null;
        }

        public static int Int(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value ? Convert.ToInt32(row[col]) : 0;
        }

        public static int? IntN(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value ? (int?)Convert.ToInt32(row[col]) : null;
        }

        public static decimal Dec(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value ? Convert.ToDecimal(row[col]) : 0m;
        }

        public static bool Bool(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value && Convert.ToBoolean(row[col]);
        }

        public static DateTime Date(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value ? Convert.ToDateTime(row[col]) : DateTime.MinValue;
        }

        public static DateTime? DateN(this DataRow row, string col)
        {
            return row.Table.Columns.Contains(col) && row[col] != DBNull.Value ? (DateTime?)Convert.ToDateTime(row[col]) : null;
        }
    }
}
