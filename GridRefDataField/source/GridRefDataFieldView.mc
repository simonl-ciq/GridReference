using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using GridRefClasses as GridRef;

using Toybox.System as Sys;

const cDigits = 6;
const cGrid = 0; // OS GB grid by default
const cBestGuess = true;

const OutSide = "Outside Grid";
const NoData = "No GPS Data";

class GridRefDataFieldView extends WatchUi.DataField {
	hidden var mOnLayoutCalled = false;
	hidden var mLaidOut = false;

    hidden var mDigits = cDigits;
    hidden var mGrid = cGrid;
    hidden var mBestGuess = cBestGuess;
    hidden var mString = "";
    
    
    hidden var mWidth;
    hidden var mValue = "AB 1234 5678";
    hidden var mTestString = "AB 1234 5678";
    hidden var mLabel = "Grid Ref";

    // Set the label of the data field here.
    function initialize() {
        DataField.initialize();
        var temp;

		if ( App has :Properties ) {
	        mDigits = Props.getValue("Digits");
	        mGrid = Props.getValue("DefaultGrid");
	        temp = Props.getValue("BestGuess");
	    } else {
	        mDigits = App.getApp().getProperty("Digits");
	        mGrid = App.getApp().getProperty("DefaultGrid");
	        temp = App.getApp().getProperty("BestGuess");
	    }
	    if (mDigits == null) {mDigits = cDigits;}
	    if (mGrid == null) {mGrid = cGrid;}
	    if (temp == null) {
	    	mBestGuess = cBestGuess;
	    } else {
	    	mBestGuess = (temp == 0);
	    }
	    if (mDigits == 4) {
	    	mTestString = "AB 12 34";
	    } else 
	    if (mDigits == 6) {
	    	mTestString = "AB 123 456";
	    } else 
	    if (mDigits == 8) {
	    	mTestString = "AB 1234 5678";
	    } else 
	    if (mDigits == 10) {
	    	mTestString = "AB 12345 67890";
	    }

    }

// ----------------------------------------------

	(:approach60)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = 4;
		} else
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (dc.getHeight() < 100) {adj = 10;} else {adj = 15;}
		}
	    return adj;
    }

	(:approach62)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = 0;
		} else
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (dc.getHeight() < 100) {adj = 15;} else {adj = 25;}
		} else
		if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (dc.getHeight() < 100) {adj = 1;}
		}
	    return adj;
    }

	(:other_round)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
    	var height = dc.getHeight();
		if (obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT) {
			adj = 5;
		} else 
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			adj = 0;
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height > 90) {
				adj = 25;
			} else {
				adj = mDigits < 8 ? 11 : 15;
			}
		}
	    return adj;
    }

	(:fr2945)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
    	var height = dc.getHeight();
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
				adj = 5;
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
				adj = 30;
		} else 
		if (obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT) {
				adj = 12;
		} else 
		if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (height > 80) {
					adj = 1;
				}
		} else 
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (height < 90) {adj = 2;}
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (height < 90) {adj = 15;}
		}
	    return adj;
    }

	(:fr55)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
    	var height = dc.getHeight();
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (height < 90) {adj = 2;}
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				if (height < 90 && mDigits != 10) {adj = 8;}
				else {adj = 15;}
		}
	    return adj;
    }

	(:fr735xt)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
		if (obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT) {
				adj = 1;
		} else 
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = 2;
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = 5;
		}
	    return adj;
    }

	(:marq)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
    	var height = dc.getHeight();
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
				adj = 5;
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
				adj = 30;
		} else 
		if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = 0;
		} else
		if (obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT) {
				adj = 0;
		} else 
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = height > 90 ? 0 : 0;
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
				adj = height > 90 ? 18 : 13;
		}
	    return adj;
    }

	(:venuair)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
		if (obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT) {
			adj = 20;
		} else
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			adj = (dc.getHeight() > 190) ? 15 : 0;
		} else
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			adj = (dc.getHeight() > 135) ? 40 : 20;
		}
	    return adj;
    }

	(:vivo)
    function getYAdjust(dc, obscurityFlags) {
    	var adj = -1;
    	var height = dc.getHeight();
		if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT) ) {
			if (height > 100) {
				adj = 16;
			} else
			if (height > 70) {
				adj = 4;
			} else {
				adj = 1;
			}
			
		} else
		if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			adj = 0;
		} else 
		if (obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT) {
			adj = 8;
		} else 
		if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height > 125) {adj = 26;}
			else if (height > 115) {adj = 15;}
			else if (height > 105) {adj = 20;}
			else if (height > 75) {adj = 18;}
			else {adj = 8;}
		}
	    return adj;
    }

	(:fenix6)
    function getYAdjust(dc, obscurityFlags) {
    	return null;
    }
    
	(:fenix6s)
    function getYAdjust(dc, obscurityFlags) {
    	return null;
    }
    
	(:fenix6xpro)
    function getYAdjust(dc, obscurityFlags) {
    	return null;
    }

// ---
	(:vivoactive_hr)
    function getYAdjust(dc, obscurityFlags) {
    	var height = dc.getHeight();
		var ret = 15;
		if (height < 80) {ret = 8;}
		else if (height < 105) {ret = 3;}
	    return ret;
    }

	(:e520_820)
    function getYAdjust(dc, obscurityFlags) {
	    return 5;
    }

	(:e530_830)
    function getYAdjust(dc, obscurityFlags) {
	    return 0;
    }

	(:e130_venusq)
    function getYAdjust(dc, obscurityFlags) {
	    return 10;
    }

	(:other_rectanglesY)
    function getYAdjust(dc, obscurityFlags) {
	    return -1;
    }

// ----------------------------------------------

	(:approach60)
    function doFont(valueView, ySpace, myF) {
		if (DataField.getObscurityFlags() != (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT) || ySpace > 50) {
			return myF;
		}
		myF = 5 - mDigits / 2;
		if (myF > 0) { myF++; }
		valueView.setFont(myF);
		return myF;
    }

	(:approach62)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		myF = Gfx.FONT_LARGE;
   		if (ySpace < 77) {
			if (mDigits > 6) {
				myF = 8 - (mDigits / 2);
				if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
					myF--;
				}
			}
		}
		valueView.setFont(myF);
		return myF;
    }

	(:other_round)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if (obs == OBSCURE_LEFT || obs == OBSCURE_RIGHT) {
			switch (mDigits) {
			case 4:
				myF = Gfx.FONT_LARGE;
				break;
			case 6:
				myF = Gfx.FONT_SMALL;
				break;
			case 8:
				myF = Gfx.FONT_TINY;
				break;
			case 10:
				myF = Gfx.FONT_XTINY;
				break;
			}
		} else 
   		if (ySpace < 77) {
			myF = Gfx.FONT_LARGE;
			if (mDigits > 6) {
				myF = 8 - (mDigits / 2);
				if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
					myF--;
				}
			}
		}
		valueView.setFont(myF);
		return myF;
    }

	(:fr2945)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT) || obs == (OBSCURE_TOP | OBSCURE_RIGHT) || obs == (OBSCURE_BOTTOM | OBSCURE_LEFT) || obs == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
			myF = Gfx.FONT_XTINY;
			if (mDigits < 8) {
	    		myF = Gfx.FONT_TINY;
	    	}
		} else
		if (obs == OBSCURE_LEFT || obs == OBSCURE_RIGHT) {
			myF = Gfx.FONT_SMALL;
			if (mDigits == 6 && ySpace < 38) {
				if (obs == OBSCURE_LEFT) {
		    		valueView.locX += 3;
				} else if (obs == OBSCURE_RIGHT) {
		    		valueView.locX -= 4;
		    	}
	    	} else
			if (mDigits == 8) {
	    		myF = (ySpace < 38) ? Gfx.FONT_XTINY : Gfx.FONT_TINY;
	    	} else
			if (mDigits == 10) {
	    		myF = Gfx.FONT_XTINY;
	    	}
		} else 
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			myF = Gfx.FONT_LARGE;
	    	if (mDigits == 8) {
	    		myF = Gfx.FONT_MEDIUM;
	    	} else if (mDigits == 10) {
				if (ySpace < 30) {
		    		myF = Gfx.FONT_SMALL;
	    		} else if (ySpace < 49) {
		    		myF = Gfx.FONT_MEDIUM;
	    		}
	    	}
		} else
		if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			myF = Gfx.FONT_LARGE;
			if (mDigits < 8) {
				if (ySpace < 50) {
		    		myF = Gfx.FONT_SMALL;
	    		}
	    	} if (mDigits == 8) {
				if (ySpace < 50) {
		    		myF = Gfx.FONT_SMALL;
	    		} else {
	    			myF = Gfx.FONT_MEDIUM;
	    		}
	    	} else if (mDigits == 10) {
				if (ySpace < 50) {
		    		myF = Gfx.FONT_TINY;
	    		} else {
	    			myF = Gfx.FONT_SMALL;
	    		}
	    	}
		}
		valueView.setFont(myF);
		return myF;
    }

	(:fr55)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT) || obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			myF = Gfx.FONT_LARGE;
	    	if ((mDigits == 6 && ySpace == 43) || mDigits == 8 || mDigits == 10) {
	    		myF = Gfx.FONT_SMALL;
	    	}
		}
		valueView.setFont(myF);
		return myF;
    }

	(:fr735xt)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if (obs == OBSCURE_LEFT || obs == OBSCURE_RIGHT) {
			switch (mDigits) {
			case 4:
				myF = Gfx.FONT_LARGE;
				break;
			case 6:
			case 8:
				myF = Gfx.FONT_MEDIUM;
				break;
			case 10:
				myF = Gfx.FONT_XTINY;
				break;
			}
		} else
		if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
	   		if (ySpace < 40 && mDigits == 10) {
   				myF = Gfx.FONT_MEDIUM;
			}
		}
		valueView.setFont(myF);
		return myF;
	}

	(:marq)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT) || obs == (OBSCURE_TOP | OBSCURE_RIGHT) || obs == (OBSCURE_BOTTOM | OBSCURE_LEFT) || obs == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
			switch (mDigits) {
			case 4:
				myF = Gfx.FONT_SMALL;
				break;
			case 6:
				myF = Gfx.FONT_TINY;
				break;
			case 8:
			case 10:
				myF = Gfx.FONT_XTINY;
				break;
			}
		} else 
		if (obs == OBSCURE_LEFT || obs == OBSCURE_RIGHT) {
			switch (mDigits) {
			case 4:
				myF = Gfx.FONT_MEDIUM;
				break;
			case 6:
				myF = Gfx.FONT_SMALL;
				break;
			case 8:
			case 10:
				myF = Gfx.FONT_XTINY;
				break;
			}
		} else
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (ySpace < 65 && mDigits == 10) {
				myF = Gfx.FONT_MEDIUM;
			}
		} else
		if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (ySpace < 65) {
				myF = (mDigits == 10) ? Gfx.FONT_SMALL : Gfx.FONT_MEDIUM;
			}
		}
		valueView.setFont(myF);
		return myF;
    }

	(:venuair)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if ((obs == (OBSCURE_LEFT | OBSCURE_RIGHT) && dc.getWidth() < 200) || obs == OBSCURE_LEFT || obs == OBSCURE_RIGHT) {
			switch (mDigits) {
			case 6:
				myF = Gfx.FONT_SMALL;
				break;
			case 8:
				myF = Gfx.FONT_TINY;
				break;
			case 10:
				myF = Gfx.FONT_XTINY;
				break;
			}
		} else
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
   			if (mDigits == 10) {
   				if (ySpace < 96) {
					myF = Gfx.FONT_SMALL;
				}
			}
   			if (mDigits == 8) {
   				if (ySpace < 90) {
					myF = Gfx.FONT_MEDIUM;
				}
			}
		} else
		if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
   			if (mDigits == 10) {
   				if (ySpace < 96) {
					myF = Gfx.FONT_SMALL;
				}
			}
   			if (mDigits == 8) {
   				if (ySpace < 90) {
					myF = Gfx.FONT_MEDIUM;
				}
			}
		}
		valueView.setFont(myF);
		return myF;
    }

	(:vivo)
    function doFont(valueView, ySpace, myF) {
		var obs = DataField.getObscurityFlags();
		if (obs == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
   			if (mDigits == 10) {
   				if (ySpace < 50) {
					myF = Gfx.FONT_TINY;
				} else
   				if (ySpace < 60) {
					myF = Gfx.FONT_SMALL;
				}
				
			} else
   			if (mDigits == 8 && ySpace < 50) {
				myF = Gfx.FONT_MEDIUM;
   			}
		} else
		if (obs == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
   			if (mDigits == 10 && ySpace < 60) {
				myF = Gfx.FONT_MEDIUM;
			}
		} else
		if (obs == OBSCURE_LEFT || obs == OBSCURE_RIGHT) {
   			if (mDigits == 10) {
				myF = Gfx.FONT_XTINY;
			} else
   			if (mDigits == 8) {
				myF = Gfx.FONT_TINY;
			} else {
				myF = Gfx.FONT_SMALL;
			}
		}
		valueView.setFont(myF);
		return myF;
    }

// ----------------------------------------------

	(:rectangle_layout)
	function doLayout(dc, yAdjust) {
       	var width = dc.getWidth()+1;

       	var valueView = View.findDrawableById("value");
        var height = dc.getHeight();
        var labelHt = dc.getFontHeight(Gfx.FONT_TINY);
		var ySpace = height - labelHt + yAdjust;
		var d = [0, 0];
		var myF = 4;
  		var f = 4;

		while (f >= 0) {
       		d = dc.getTextDimensions(mTestString, f);
   			myF = f;
    		if (d[0] <= width && d[1] <= ySpace) {
		   		break;
       		}
       		f = f-1;
       	}

   		var valueAsc = Graphics.getFontAscent(myF);
        valueView.setFont(myF);
		valueView.locY = labelHt + ((ySpace - valueAsc - 2) / 2) - yAdjust;
	}

	(:round_layout)
	function doLayout(dc, yAdjust) {

       	var width = dc.getWidth();

		if (yAdjust >= 0) {
	        var height = dc.getHeight();
    	    var labelHt = dc.getFontHeight(Gfx.FONT_TINY);
	       	var labelView = View.findDrawableById("label");
    	   	var valueView = View.findDrawableById("value");
			var ySpace = height - labelView.locY - labelHt;
			var myF = doFont(valueView, ySpace, Gfx.FONT_LARGE);
			var fh = dc.getFontHeight(myF);
			valueView.locY = labelView.locY + labelHt  + (ySpace - fh) / 2 - yAdjust;
	    } else {
    	   	var valueView = View.findDrawableById("value");
			var y = valueView.locY;
	    }
	}

	(:fenix6s)
	function doLayout(dc, yAdjust) {
        var obscurityFlags = DataField.getObscurityFlags();
       	var width = dc.getWidth();
        var height = dc.getHeight();
   	   	var valueView = View.findDrawableById("value");
       	var myF = Gfx.FONT_LARGE;

        // Top left quadrant so we'll use the top left layout - 3
        // Top right quadrant so we'll use the top right layout - 6

        // Top sector so we'll use the generic, centered layout shifted - 7
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 70) {
				if (mDigits < 8) {
					valueView.locY -= 41;
					if (mDigits == 6) {
						myF = Gfx.FONT_MEDIUM;
					}
				} else {
					myF = Gfx.FONT_SMALL;
					valueView.locY -= 35;
				}
			} else if (height < 90) {
				valueView.locY -= 25;
				switch (mDigits) {
				case 6:
					myF = Gfx.FONT_LARGE;
					break;
				case 8:
					myF = Gfx.FONT_MEDIUM;
					break;
				case 10:
					myF = Gfx.FONT_MEDIUM;
					break;
				}
			}
        // Middle sector so we'll use the generic, centered layout shrunk - 5
        } else if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 60) {
//				myF = Gfx.FONT_MEDIUM;
				valueView.locY -= 4;
			} else if (height > 80) {
				valueView.locY += 10;
			}
        // Middle sector left so we'll use the generic, centered layout shrunk - 1
        } else if (obscurityFlags == (OBSCURE_LEFT)) {
        	switch (mDigits) {
        	case 10:
        	case  8:
        		myF = Gfx.FONT_XTINY;
				if (height < 65) {
					View.findDrawableById("label").locX += 4;
					valueView.locX += 4;
					valueView.locY += 4;
				} else {
					valueView.locY += 8;
				}
        		break;
        	case  6:
        		myF = Gfx.FONT_SMALL;
				if (height < 65) {
					View.findDrawableById("label").locX += 3;
					valueView.locX += 3;
					valueView.locY -= 5;
				} else {
					valueView.locY += 4;
				}
        		break;
        	case  4:
        		myF = Gfx.FONT_MEDIUM;
				if (height < 65) {
					View.findDrawableById("label").locX += 4;
					valueView.locX += 4;
					valueView.locY -= 2;
				} else {
					valueView.locY += 3;
				}
        		break;
        	}
        // Middle sector right so we'll use the generic, centered layout shrunk - 4
        } else if (obscurityFlags == (OBSCURE_RIGHT)) {
        	switch (mDigits) {
        	case 10:
        	case  8:
        		myF = Gfx.FONT_XTINY;
				if (height < 65) {
					View.findDrawableById("label").locX -= 4;
					valueView.locX -= 4;
					valueView.locY += 4;
				} else {
					valueView.locY += 8;
				}
        		break;
        	case  6:
        		myF = Gfx.FONT_SMALL;
				if (height < 65) {
					View.findDrawableById("label").locX -= 3;
					valueView.locX -= 3;
					valueView.locY -= 5;
				} else {
					valueView.locY += 4;
				}
        		break;
        	case  4:
        		myF = Gfx.FONT_MEDIUM;
				if (height < 65) {
					View.findDrawableById("label").locX -= 4;
					valueView.locX -= 4;
					valueView.locY -= 2;
				} else {
					valueView.locY += 3;
				}
        		break;
        	}

        // Top left quadrant so we'll use the bottom left layout - 9
        // Top right quadrant so we'll use the bottom right layout - 12
        // Bottom left quadrant so we'll use the bottom left layout - 9
        // Bottom right quadrant so we'll use the bottom right layout - 12
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT) ||
                   obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT) ) {
        	switch (mDigits) {
        	case 10:
        	case  8:
        		myF = Gfx.FONT_XTINY;
        		break;
        	case  6:
        		myF = Gfx.FONT_TINY;
				valueView.locY -= 8;
        		break;
        	case  4:
        		myF = Gfx.FONT_MEDIUM;
				valueView.locY -= 12;
        		break;
        	}
        // Bottom sector so we'll use the generic, centered layout upside down - 13
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 70) {
				switch (mDigits) {
				case 10:
					valueView.locY -= 6;
				case 8:
					myF = Gfx.FONT_TINY;
					valueView.locY -= 2;
					break;
				case 6:
					myF = Gfx.FONT_SMALL;
					valueView.locY -= 2;
					break;
				case 4:
					myF = Gfx.FONT_MEDIUM;
					valueView.locY -= 4;
					break;
				}
			} else if (height < 100) {
				if (mDigits == 10) {
					if (height > 77) {
						myF = Gfx.FONT_MEDIUM;
						if (height > 80) {
							valueView.locY -= 8;
						} else {
							valueView.locY -= 7;
						}
					} else {
						myF = Gfx.FONT_SMALL;
					}
				}
				else if (mDigits == 8) {
					myF = Gfx.FONT_MEDIUM;
					if (height > 76) {
						valueView.locY += 4;
					} else {
						valueView.locY -= 4;
					}
				}
				else if (mDigits == 6 && height > 76) {
					valueView.locY += 6;
				}
				else if (mDigits == 4) {
					if (height > 76) {
						valueView.locY += 8;
					} else {
						valueView.locY += 6;
					}
				}
			}
			else if (mDigits < 10) {
				valueView.locY += 15;
			}
		}

		if (myF != null) {
			valueView.setFont(myF);
		}
	}

	(:fenix6)
	function doLayout(dc, yAdjust) {
        var obscurityFlags = DataField.getObscurityFlags();
       	var width = dc.getWidth();
        var height = dc.getHeight();
   	   	var valueView = View.findDrawableById("value");
       	var myF = Gfx.FONT_LARGE;

        // Top left quadrant so we'll use the top left layout - 3
        // Top right quadrant so we'll use the top right layout - 6

        // Top sector so we'll use the generic, centered layout shifted - 7
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 70) {
				if (mDigits < 8) {
					valueView.locY -= 41;
					if (mDigits == 6) {
						myF = Gfx.FONT_MEDIUM;
					}
				} else {
					myF = Gfx.FONT_SMALL;
					valueView.locY -= 35;
				}
			} else if (height < 90) {
				valueView.locY -= 25;
				switch (mDigits) {
				case 6:
					myF = Gfx.FONT_MEDIUM;
					break;
				case 8:
					myF = Gfx.FONT_MEDIUM;
					break;
				case 10:
					myF = Gfx.FONT_SMALL;
					break;
				}
			} else if (height < 100) {
				if (mDigits < 10) {
					valueView.locY -= 20;
				} else {
					valueView.locY -= 12;
				}
			}
        // Middle sector so we'll use the generic, centered layout shrunk - 5
        } else if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 60) {
				myF = Gfx.FONT_TINY;
			} else if (height < 70) {
				myF = Gfx.FONT_LARGE;
				valueView.locY -= 12;
			} else if (height < 85) {
				valueView.locY -= 3;
			}
        // Middle sector left so we'll use the generic, centered layout shrunk - 1
        } else if (obscurityFlags == (OBSCURE_LEFT)) {
        	switch (mDigits) {
        	case 10:
        	case  8:
        		myF = Gfx.FONT_XTINY;
        		break;
        	case  6:
        		myF = Gfx.FONT_SMALL;
        		break;
        	case  4:
        		myF = Gfx.FONT_MEDIUM;
        		break;
        	}
			if (height < 70) {
				valueView.locY -= 12;
			} else {
		   	   	var labelView = View.findDrawableById("label");
				labelView.locX -= 3;
				valueView.locX -= 3;
				valueView.locY -= 5;
			}
        // Middle sector right so we'll use the generic, centered layout shrunk - 4
        } else if (obscurityFlags == (OBSCURE_RIGHT)) {
        	if (mDigits > 6) {myF = Gfx.FONT_XTINY;}
        	else if (mDigits == 6) {myF = Gfx.FONT_SMALL;}
        	else if (mDigits < 6) {myF = Gfx.FONT_MEDIUM;}
			if (height < 70) {
				valueView.locY -= 12;
			} else {
		   	   	var labelView = View.findDrawableById("label");
				labelView.locX += 3;
				valueView.locX += 3;
				valueView.locY -= 5;
			}

        // Top left quadrant so we'll use the bottom left layout - 9
        // Top right quadrant so we'll use the bottom right layout - 12
        // Bottom left quadrant so we'll use the bottom left layout - 9
        // Bottom right quadrant so we'll use the bottom right layout - 12
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT) ||
                   obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT) || obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT) ) {
        	switch (mDigits) {
        	case 10:
        	case  8:
        		myF = Gfx.FONT_XTINY;
        		break;
        	case  6:
        		myF = Gfx.FONT_TINY;
				valueView.locY -= 8;
        		break;
        	case  4:
        		myF = Gfx.FONT_MEDIUM;
				valueView.locY -= 12;
        		break;
        	}
        // Bottom sector so we'll use the generic, centered layout upside down - 13
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 70) {
				if (mDigits == 10) {myF = Gfx.FONT_TINY;}
				else if (mDigits == 8) {myF = Gfx.FONT_SMALL;}
				else if (mDigits == 6) {myF = Gfx.FONT_MEDIUM;}
				valueView.locY -= 11;
			} else if (height < 100) {
				if (mDigits == 10) {myF = Gfx.FONT_SMALL;}
				else if (mDigits == 8) {myF = Gfx.FONT_MEDIUM;}
				if (height < 88) {
					valueView.locY -= 6;
				} else {
					valueView.locY += 3;
				}
			}
		}

		if (myF != null) {
			valueView.setFont(myF);
		}
	}

	(:fenix6xpro)
	function doLayout(dc, yAdjust) {
        var obscurityFlags = DataField.getObscurityFlags();
       	var width = dc.getWidth();
        var height = dc.getHeight();
   	   	var valueView = View.findDrawableById("value");
       	var myF = null;

        // Top left quadrant so we'll use the top left layout - 3
        // Top right quadrant so we'll use the top right layout - 6

        // Top sector so we'll use the generic, centered layout shifted - 7
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 50) {
				myF = Gfx.FONT_TINY; valueView.locY -= 15;
			} else if (height < 75) {
				myF = (mDigits > 6) ? Gfx.FONT_SMALL : Gfx.FONT_MEDIUM; valueView.locY -= 5;
			} else if (height < 110) {
				myF = (mDigits > 6) ? Gfx.FONT_MEDIUM : Gfx.FONT_LARGE; valueView.locY += 12;
			} else {
				myF = Gfx.FONT_LARGE; valueView.locY += 35;
			}

        // Middle sector so we'll use the generic, centered layout shrunk - 5
        } else if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 65) {
				valueView.locY += 10;
			} else if (height < 75) {
				valueView.locY += 15;
			} else if (height < 93) {
				valueView.locY += 20;
			} else {
				valueView.locY += 30;
			}

        // Middle sector left so we'll use the generic, centered layout shrunk - 1
        } else if (obscurityFlags == (OBSCURE_LEFT)) {
			if (height < 65) {
				valueView.locX += 8;
				valueView.locY += 10;
			} else if (height < 75) {
    	    	if (mDigits < 8) {myF = Gfx.FONT_TINY;valueView.locY -= 10;}
				valueView.locY += 15;
			} else {
        		if (mDigits < 8) {myF = Gfx.FONT_SMALL;}
				valueView.locY += 15;
			}
        // Middle sector right so we'll use the generic, centered layout shrunk - 4
        } else if (obscurityFlags == (OBSCURE_RIGHT)) {
			if (height < 65) {
				valueView.locX -= 8;
				valueView.locY += 10;
			} else if (height < 75) {
    	    	if (mDigits < 8) {myF = Gfx.FONT_TINY;valueView.locY -= 10;}
				valueView.locY += 15;
			} else {
	        	if (mDigits < 8) {myF = Gfx.FONT_SMALL;}
				valueView.locY += 15;
			}

        // Bottom sector so we'll use the generic, centered layout upside down - 13
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
			if (height < 60) {
				myF = Gfx.FONT_XTINY; valueView.locY += 4;
			} else if (height < 75) {
				myF = (mDigits > 6) ? Gfx.FONT_TINY : Gfx.FONT_SMALL; valueView.locY -= 1;
			} else if (height < 97) {
				if (mDigits < 8) {
					myF = Gfx.FONT_LARGE;
				} else if (mDigits == 8) {
					myF = Gfx.FONT_MEDIUM;
				} else {
					myF = Gfx.FONT_SMALL;
				}
				valueView.locY += 5;
			} else if (height < 110) {
				if (mDigits < 8) {
					myF = Gfx.FONT_LARGE;
				} else if (mDigits == 8) {
					myF = Gfx.FONT_MEDIUM;
				} else {
					myF = Gfx.FONT_SMALL;
				}
				valueView.locY += 10;
			} else {
				myF = Gfx.FONT_LARGE; valueView.locY += 20;
			}
        } else if 	(obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT) ||
        			 obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT) ||
        			 obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT) ||
        			 obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
			if (mDigits < 8) {
				myF = Gfx.FONT_TINY;
				if (mDigits == 6 && (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT) ||
				        			 obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT))) {
					valueView.locX -= 4;
				} else if (mDigits == 4) {
					valueView.locX += 8;
				}
				valueView.locY -= 15;
			}
		}

		if (myF != null) {
			valueView.setFont(myF);
		}
        // Bottom left quadrant so we'll use the bottom left layout - 9
        // Bottom right quadrant so we'll use the bottom right layout - 12
        // Use the generic, centered layout
	}

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
    	mOnLayoutCalled = true;
    	mLaidOut = false;
        return true;
    }

(:not_venuair)
    function venuBugfix (dc, obscurityFlags) {
        // Middle sector so we'll use the generic, centered layout shrunk - 5
        if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.MiddleCentreLayout(dc));

        // Middle sector left so we'll use the generic, centered layout shrunk - 1
        } else if (obscurityFlags == (OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.MiddleLeftLayout(dc));

        // Middle sector right so we'll use the generic, centered layout shrunk - 4
        } else if (obscurityFlags == (OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.MiddleRightLayout(dc));
        }
    }

(:venuair)    
    function venuBugfix (dc, obscurityFlags) {
        // Middle sector so we'll use the generic, centered layout shrunk - 5
        if (dc.getWidth() > 200) {
            View.setLayout(Rez.Layouts.MiddleCentreLayout(dc));

        // Middle sector left so we'll use the generic, centered layout shrunk - 1
        // Middle sector right so we'll use the generic, centered layout shrunk - 4
        // Left & right layouts are the same for Venu
        } else {
            View.setLayout(Rez.Layouts.MiddleLeftLayout(dc));
        }
    }

    function myLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout - 3
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout - 6
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Top sector so we'll use the generic, centered layout shifted - 7
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopCentreLayout(dc));

        // Middle sectors so we'll use the generic, centered layout shrunk - 1/4/5
        } else if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT) || obscurityFlags == OBSCURE_LEFT || obscurityFlags == OBSCURE_RIGHT ) {
            venuBugfix(dc, obscurityFlags);

        // Bottom sector so we'll use the generic, centered layout upside down - 13
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomCentreLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout - 9
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout - 12
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }

        var adj = getYAdjust(dc, obscurityFlags);
		doLayout(dc, adj);

        View.findDrawableById("label").setText(Rez.Strings.label);

        return true;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
		var Accuracy = 2;
//		    Accuracy = 1; // for testing / debugging
		
		mString = NoData;

	    if (info has :currentLocationAccuracy && info.currentLocationAccuracy != null) {
	    	Accuracy = info.currentLocationAccuracy;
	    }
		if (info has :currentLocation && info.currentLocation != null && Accuracy > 1) {
			var useGrid = mGrid;
			var rads = info.currentLocation.toRadians();
// rads = Position.parse("52.479613, -10.944677", Position.GEO_DEG).toRadians();
//   0.968 is 55.462315 degrees North, (Tor Rocks north of Inishtrahull) further North is treated as GB
//  -0.093 is 5.328507 degrees West (East of Cannon Rock), further East is treated as GB
//   0.896 is 51.337021 degrees North, (Fastnet Rock) further South is treated as GB
//   0.963, -0.102 55.175835, -5.844170 SW of Mull of Kintyre
//   0.908, -0.102, > 52.024567, -5.844170 NW of St David's Head
// By default, unless otherwise set, try Ireland first unless too far east or north. In the overlap the chosen default grid will be used.
			if (mBestGuess) {
				if (rads[1] > -0.093 || rads[0] > 0.968 || rads[0] < 0.896) { useGrid = 0; } else
				if (rads[1] > -0.102 && (rads[0] > 0.963 || rads[0] < 0.908)) { useGrid = 0; }
				else { useGrid = 1; }
			}

			var gr = GridRef.OSGridArray(useGrid, rads, mDigits);
			if (gr[0].equals(OutSide)) {
// Try the other grid
				gr = GridRef.OSGridArray(((useGrid + 1) % 2), rads, mDigits);
			}
    		mString = gr[0];
			if (!gr[0].equals(OutSide)) {
		    	mString += (" " + gr[1] + " " + gr[2]);
	    	}
	    }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
		if (!mOnLayoutCalled) {
			return;
		} else if (!mLaidOut) {
			mLaidOut = myLayout(dc);
		}
		
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

//        var labelView = View.findDrawableById("label");

        // Set the foreground color and value
        var valueView = View.findDrawableById("value");
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            valueView.setColor(Graphics.COLOR_WHITE);
        } else {
            valueView.setColor(Graphics.COLOR_BLACK);
        }

//mString = "SJ 541 772";
        valueView.setText(mString);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
