//
//  Shader.fsh
//  TomsCube
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

varying lowp vec3 colorVarying;

void main()
{
    gl_FragColor = vec4(colorVarying, 1.0);
}