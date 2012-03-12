//
//  Shader.fsh
//  TomsCube
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
