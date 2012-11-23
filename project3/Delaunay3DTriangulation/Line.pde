/**
 * @class Line
 */
class Line {
    pt start;
    pt end;
    
    /**
     * @function Line
     * @brief Constructor
     */
    Line( pt _start, pt _end ) {
        start = _start;
        end = _end;
    }

    /**
     * @function reverse
     * @brief ************ ADDED CONSTRUCTOR V() CHECK IF ERROR
     */
    void reverse() {
        pt tmp = P(start);
        start = P(end);
        end = tmp;
    }

    /**
     * @function equals
     */
    boolean equals(Line l) {
        if ( (start == l.start && end == l.end)
                || (start == l.end && end == l.start) ) {
          return true;
        }
        else {
          return false;
        }
    }
};
