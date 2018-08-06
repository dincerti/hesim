# ifndef HESIM_UTILS_H
# define HESIM_UTILS_H
#include <RcppArmadillo.h>

namespace hesim{

typedef std::vector<arma::mat> vecmats;
typedef std::vector<vecmats> vecmats_2d;
typedef std::vector<vecmats_2d> vecmats_3d;
typedef std::vector<std::string> vecstrings;
typedef std::vector<vecstrings> vecstrings_2d;
typedef std::vector<arma::cube> vec_cubes;

/** 
 * @ingroup general
 *Internal details for hesim that should be ignored by external users.*/
namespace detail {

/**
 * Convert an Rcpp::List to a vector  
 * @param l An Rcpp::List 
 * @tparam T1 The class of the object to create (e.g., std::vector<arma::mat>).
 * @tparam T2 The class of each element of the vector (e.g., arma::mat).
 * @return A vector of type T1
 */
template <typename T1, typename T2> 
T1 list_to_vec(Rcpp::List l){
  T1 v;
  int n = l.size();
  v.reserve(n);
  for (int i = 0; i < n; ++i){
    v.push_back(Rcpp::as<T2 >(l[i]));
  }
  return v;
}

} //end namespace detail

/**
 * @ingroup general
 * Find the position of the largest element in the range
 * [first,last) from a container in the Standard 
 * Library.
 * @param first, last Forward iterators defining the range to examine 
 */
template <typename InputIt>
inline int max_element_pos(InputIt first, InputIt last) {
  auto it = std::max_element(first, last);
  return std::distance(first, it);
}

/**
 * @ingroup general
 * Sort a vector in the standard library and
 * erase duplicates.
 * @param v A vector.
 * @return None. 
 */
template <typename T>
inline void unique(std::vector<T> &v){
  std::sort(v.begin(), v.end());
  v.erase(std::unique(v.begin(), v.end()), v.end());
}

/**
 * @ingroup general
 * Add a constant value to a vector in the Standard
 * Library. 
 * @param v A vector. Should be of type integer
 * or double.
 * @param value A value to add to each element
 * in the vector. 
 * @return None.
 */
template <typename T>
inline void add_constant(std::vector<T> &v, double value){
  std::transform(v.begin(), v.end(), v.begin(),
                 std::bind2nd(std::plus<double>(), value)); 
}

} // end hesim namespace


/****************************
* Custom Rcpp::as converters
****************************/
namespace Rcpp {
  inline hesim::vecmats as(SEXP object) {
    Rcpp::List l = Rcpp::as<Rcpp::List>(object);
    return hesim::detail::list_to_vec<hesim::vecmats, arma::mat>(l);
  }
  
  template <> inline hesim::vecmats_2d as(SEXP object) {
    Rcpp::List l = Rcpp::as<Rcpp::List>(object);
    return hesim::detail::list_to_vec<hesim::vecmats_2d, hesim::vecmats>(l);
  }
  
  template <> inline hesim::vecmats_3d as(SEXP object) {
    Rcpp::List l = Rcpp::as<Rcpp::List>(object);
    return hesim::detail::list_to_vec<hesim::vecmats_3d, hesim::vecmats_2d> (l);
  }
  
  template <> inline hesim::vecstrings_2d as(SEXP object) {
    Rcpp::List l = Rcpp::as<Rcpp::List>(object);
    return hesim::detail::list_to_vec<hesim::vecstrings_2d, hesim::vecstrings> (l);
  }
} // end Rcpp namespace



# endif